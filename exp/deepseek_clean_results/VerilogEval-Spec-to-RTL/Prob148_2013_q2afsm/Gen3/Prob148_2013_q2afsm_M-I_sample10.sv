module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    parameter [2:0] IDLE  = 3'b000,
                    GRANT0 = 3'b001,
                    GRANT1 = 3'b010,
                    GRANT2 = 3'b100;

    reg [2:0] state, next_state;
    wire clk_gated;

    // Clock gating when in IDLE state
    assign clk_gated = clk & (|state | |r);

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                casez (r)
                    3'b1??: next_state = GRANT0;  // r[0] has highest priority
                    3'b01?: next_state = GRANT1;  // r[1] next priority
                    3'b001: next_state = GRANT2;  // r[2] lowest priority
                    default: next_state = IDLE;
                endcase
            end
            GRANT0: next_state = r[0] ? GRANT0 : IDLE;
            GRANT1: next_state = r[1] ? GRANT1 : IDLE;
            GRANT2: next_state = r[2] ? GRANT2 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register (clock gated)
    always @(posedge clk_gated or negedge resetn) begin
        if (!resetn) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Output generation
    assign g[0] = (state == GRANT0);
    assign g[1] = (state == GRANT1);
    assign g[2] = (state == GRANT2);

endmodule