module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Create a 4-bit selector {current_state, x}
    wire [3:0] selector = {y, x};

    // Next state lookup table
    reg [2:0] next_state;
    always @(*) begin
        case (selector)
            4'b0000: next_state = 3'b000; // State 000, x=0
            4'b0001: next_state = 3'b001; // State 000, x=1
            4'b0010: next_state = 3'b001; // State 001, x=0
            4'b0011: next_state = 3'b100; // State 001, x=1
            4'b0100: next_state = 3'b010; // State 010, x=0
            4'b0101: next_state = 3'b001; // State 010, x=1
            4'b0110: next_state = 3'b001; // State 011, x=0
            4'b0111: next_state = 3'b010; // State 011, x=1
            4'b1000: next_state = 3'b011; // State 100, x=0
            4'b1001: next_state = 3'b100; // State 100, x=1
            default: next_state = 3'b000; // Default case
        endcase
    end

    // Output logic
    assign Y0 = next_state[0];
    assign z = (y == 3'b011) | (y == 3'b100);

endmodule