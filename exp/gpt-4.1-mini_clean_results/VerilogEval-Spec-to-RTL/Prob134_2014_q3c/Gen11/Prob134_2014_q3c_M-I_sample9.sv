module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    reg [2:0] next_state;

    // Combinational block: next state logic as direct case statement
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

    // Output z is high only for states 3 (011) and 4 (100)
    // Using a 5-bit mask with bits at positions 3 and 4 set: 5'b11000
    // y ranges 0-4, so we check if bit y is set in the mask
    wire [4:0] z_mask = 5'b11000;
    assign z = (y < 5) ? z_mask[y] : 1'b0;

    // Y0 is the least significant bit of next_state
    assign Y0 = next_state[0];

endmodule