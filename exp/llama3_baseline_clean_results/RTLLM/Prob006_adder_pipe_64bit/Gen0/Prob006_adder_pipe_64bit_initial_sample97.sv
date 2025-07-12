module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Register the input enable signal
reg i_en_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i_en_reg <= 1'b0;
    end else begin
        i_en_reg <= i_en;
    end
end

// Define the ripple carry adder
wire [63:0] sum;
wire cout;
assign sum = adda + addb;
assign cout = (adda[63] & addb[63]) | (adda[63] & sum[63]) | (addb[63] & sum[63]);

// Register the sum and carry values
reg [63:0] sum_reg;
reg cout_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg <= 64'd0;
        cout_reg <= 1'b0;
    end else if (i_en_reg) begin
        sum_reg <= sum;
        cout_reg <= cout;
    end
end

// Register the output result
reg [64:0] result_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result_reg <= 65'd0;
    end else if (i_en_reg) begin
        result_reg <= {cout_reg, sum_reg};
    end
end

// Update the output enable signal
reg o_en_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_en_reg <= 1'b0;
    end else if (i_en_reg) begin
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

// Assign the output ports
assign result = result_reg;
assign o_en = o_en_reg;

endmodule