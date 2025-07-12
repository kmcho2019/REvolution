module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] next_y;
reg [2:0] curr_y;

always @(posedge clk) begin
    curr_y <= next_y;
end

always @(*) begin
    case (curr_y)
        3'b000: next_y = (x == 1'b0) ? 3'b000 : 3'b001;
        3'b001: next_y = (x == 1'b0) ? 3'b001 : 3'b100;
        3'b010: next_y = (x == 1'b0) ? 3'b010 : 3'b001;
        3'b011: next_y = (x == 1'b0) ? 3'b001 : 3'b010;
        3'b100: next_y = (x == 1'b0) ? 3'b011 : 3'b100;
        default: next_y = 3'b000; // default next state
    endcase
end

always @(*) begin
    case (curr_y)
        3'b000, 3'b001, 3'b010: z = 1'b0;
        3'b011, 3'b100: z = 1'b1;
        default: z = 1'b0; // default output
    endcase
end

assign Y0 = next_y[0];

endmodule