module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    reg [2:0] next_state;
    reg       z_reg;

    // Combinational next state logic using direct case statement
    always @(*) begin
        case (y)
            3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
            default: next_state = 3'b000;
        endcase
    end

    // Output z encoded as a bitmask: high only for states 3'b011 and 3'b100
    // Use a 8-bit vector for quick lookup
    wire [7:0] z_mask = 8'b00011000; // bit 3 and bit 4 are set
    assign z = z_mask[y];

    // Y0 is the LSB of the next state
    assign Y0 = next_state[0];

endmodule