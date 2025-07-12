module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] Y;
reg [2:0] next_Y;

always @(*) begin
    case (y)
        3'b000: next_Y = (x == 1'b0) ? 3'b000 : 3'b001;
        3'b001: next_Y = (x == 1'b0) ? 3'b001 : 3'b100;
        3'b010: next_Y = (x == 1'b0) ? 3'b010 : 3'b001;
        3'b011: next_Y = (x == 1'b0) ? 3'b001 : 3'b010;
        3'b100: next_Y = (x == 1'b0) ? 3'b011 : 3'b100;
        default: next_Y = 3'b000; // Default next state
    endcase

    Y0 = next_Y[0]; // Output Y0 is Y[0] of the next state

    // Output z logic
    case ({y, x})
        {3'b000, 1'b0}, {3'b001, 1'b0}, {3'b010, 1'b0}, {3'b011, 1'b1}, {3'b100, 1'b1}: z = 1'b1;
        default: z = 1'b0;
    endcase
end

always @(posedge clk) begin
    Y <= next_Y;
end

endmodule