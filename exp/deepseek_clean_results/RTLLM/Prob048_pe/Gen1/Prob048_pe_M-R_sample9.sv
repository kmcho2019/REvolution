module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

wire signed [31:0] product;
wire signed [31:0] next_c;

// Combinational logic for MAC operation
assign product = a * b;
assign next_c = c + product;

// Sequential logic for register update
always @(posedge clk) begin
    if (rst) begin
        c <= 32'd0;
    end
    else begin
        c <= next_c;
    end
end

endmodule