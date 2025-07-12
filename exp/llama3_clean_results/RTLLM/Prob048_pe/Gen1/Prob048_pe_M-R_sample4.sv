module pe (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] c
);

// Combinational logic for multiplication
wire [31:0] product;
assign product = a * b;

// Separate always block for reset condition handling
always @ (posedge rst) begin
    if (rst) begin
        c <= 32'd0;
    end
end

// Always block for clocked operations
always @ (posedge clk) begin
    if (!rst) begin
        c <= c + product;
    end
end

endmodule