module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // One-hot state encoding
    localparam STATE_A = 3'b000;
    localparam STATE_B = 3'b001;
    localparam STATE_C = 3'b010;
    localparam STATE_D = 3'b100;
    
    reg [2:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            STATE_A: begin
                if (r[0]) next_state = STATE_B;
                else if (r[1]) next_state = STATE_C;
                else if (r[2]) next_state = STATE_D;
                else next_state = STATE_A;
            end
            STATE_B: begin
                if (r[0]) next_state = STATE_B;
                else next_state = STATE_A;
            end
            STATE_C: begin
                if (r[1]) next_state = STATE_C;
                else next_state = STATE_A;
            end
            STATE_D: begin
                next_state = STATE_A; // State D not shown in original spec
            end
            default: next_state = STATE_A;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
        end else begin
            state <= next_state;
        end
    end

    // Output logic - purely combinational
    always @(*) begin
        case (state)
            STATE_B: g = 3'b001;
            STATE_C: g = 3'b010;
            STATE_D: g = 3'b100;
            default: g = 3'b000;
        endcase
    end

endmodule