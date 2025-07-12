module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding
    // 00: idle (A)
    // 01: grant device 0 (B)
    // 10: grant device 1 (C)
    // 11: grant device 2 (D)
    reg [1:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 2'b00; // idle
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            2'b00: // idle
                if (r[0]) next_state = 2'b01;
                else if (r[1]) next_state = 2'b10;
                else if (r[2]) next_state = 2'b11;
                else next_state = 2'b00;
            2'b01: // grant device 0
                next_state = r[0] ? 2'b01 : 2'b00;
            2'b10: // grant device 1
                next_state = r[1] ? 2'b10 : 2'b00;
            2'b11: // grant device 2
                next_state = r[2] ? 2'b11 : 2'b00;
            default:
                next_state = 2'b00;
        endcase
    end

    // Grant outputs directly from state bits using simple combinational assignment
    assign g = (state == 2'b01) ? 3'b001 :
               (state == 2'b10) ? 3'b010 :
               (state == 2'b11) ? 3'b100 : 3'b000;

endmodule