module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] Y; // current state
reg [2:0] next_Y; // next state

always @(*) begin
    case (Y)
        3'b000: next_Y = (x) ? 3'b001 : 3'b000;
        3'b001: next_Y = (x) ? 3'b100 : 3'b001;
        3'b010: next_Y = (x) ? 3'b001 : 3'b010;
        3'b011: next_Y = (x) ? 3'b010 : 3'b001;
        3'b100: next_Y = (x) ? 3'b100 : 3'b011;
        default: next_Y = 3'b000; // default next state
    endcase

    case (Y)
        3'b000, 3'b001, 3'b010: z = 0;
        3'b011, 3'b100: z = 1;
        default: z = 0; // default output
    endcase
end

always @(posedge clk) begin
    Y <= next_Y; // update current state on the positive edge of the clock
end

assign Y0 = Y[0]; // output Y0 is the 0th bit of the current state Y

endmodule