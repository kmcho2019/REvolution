module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

    // State encoding (2-bit binary):
    // 2'b00: idle (A)
    // 2'b01: grant device 0 (B)
    // 2'b10: grant device 1 (C)
    // 2'b11: grant device 2 (D)
    reg [1:0] state, next_state;

    // Sequential logic: synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= 2'b00; // reset to idle (A)
        else
            state <= next_state;
    end

    // Combinational next state logic with priority
    always @(*) begin
        case (state)
            2'b00: begin // idle (A)
                if      (r[0]) next_state = 2'b01; // grant device 0 (B)
                else if (r[1]) next_state = 2'b10; // grant device 1 (C)
                else if (r[2]) next_state = 2'b11; // grant device 2 (D)
                else           next_state = 2'b00; // stay idle
            end

            2'b01: // grant device 0 (B)
                next_state = r[0] ? 2'b01 : 2'b00;

            2'b10: // grant device 1 (C)
                next_state = r[1] ? 2'b10 : 2'b00;

            2'b11: // grant device 2 (D)
                next_state = r[2] ? 2'b11 : 2'b00;

            default: // safe fallback to idle
                next_state = 2'b00;
        endcase
    end

    // Output grant decoding from binary state
    assign g = (state == 2'b01) ? 3'b001 :
               (state == 2'b10) ? 3'b010 :
               (state == 2'b11) ? 3'b100 :
                                  3'b000;

endmodule