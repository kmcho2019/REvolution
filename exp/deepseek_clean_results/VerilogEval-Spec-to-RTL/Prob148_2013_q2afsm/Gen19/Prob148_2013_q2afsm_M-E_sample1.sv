module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // State encoding using minimal binary representation
    parameter [1:0] IDLE  = 2'b00;
    parameter [1:0] G0    = 2'b01;
    parameter [1:0] G1    = 2'b10;
    parameter [1:0] G2    = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] grant_hold;  // Tracks which grant is currently active

    // Next state logic with priority handling
    always @(*) begin
        case (state)
            IDLE: begin
                if (r[0])       next_state = G0;
                else if (r[1])  next_state = G1;
                else if (r[2])  next_state = G2;
                else            next_state = IDLE;
            end
            G0: next_state = r[0] ? G0 : IDLE;
            G1: next_state = r[1] ? G1 : IDLE;
            G2: next_state = r[2] ? G2 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State transition and grant tracking
    always @(posedge clk) begin
        if (!resetn) begin
            state <= IDLE;
            grant_hold <= 3'b000;
        end else begin
            state <= next_state;
            
            // Update grant tracking
            case (next_state)
                G0: grant_hold <= 3'b001;
                G1: grant_hold <= 3'b010;
                G2: grant_hold <= 3'b100;
                default: grant_hold <= 3'b000;
            endcase
        end
    end

    // Output generation - combines current grant and state
    always @(*) begin
        g = 3'b000;
        case (state)
            G0: g[0] = 1'b1;
            G1: g[1] = 1'b1;
            G2: g[2] = 1'b1;
            default: g = 3'b000;
        endcase
    end

endmodule