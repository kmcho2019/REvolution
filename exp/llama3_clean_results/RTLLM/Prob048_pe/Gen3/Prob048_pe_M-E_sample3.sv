module pe (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] c
);

// Booth multiplier
reg [31:0] product;
reg [31:0] temp;

always @ (posedge clk) begin
    if (rst) begin
        product <= 0;
    end else begin
        temp <= a * b;
        product <= temp;
    end
end

// Pipelined accumulator
reg [31:0] pipeline_reg1;
reg [31:0] pipeline_reg2;

always @ (posedge clk) begin
    if (rst) begin
        pipeline_reg1 <= 0;
        pipeline_reg2 <= 0;
    end else begin
        pipeline_reg1 <= product;
        pipeline_reg2 <= pipeline_reg1 + c;
    end
end

assign c = pipeline_reg2;

endmodule