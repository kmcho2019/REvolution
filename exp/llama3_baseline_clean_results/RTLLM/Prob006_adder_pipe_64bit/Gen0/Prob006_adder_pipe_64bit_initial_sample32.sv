module adder_pipe_64bit (
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [63:0] adda_pipe;
reg [63:0] addb_pipe;
reg [64:0] sum_pipe;
reg         i_en_pipe;
reg         o_en_pipe;

// Synchronize the input enable signal and input operands
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i_en_pipe <= 1'b0;
        adda_pipe <= 64'd0;
        addb_pipe <= 64'd0;
    end else if (i_en) begin
        i_en_pipe <= 1'b1;
        adda_pipe <= adda;
        addb_pipe <= addb;
    end else begin
        i_en_pipe <= 1'b0;
        adda_pipe <= adda_pipe;
        addb_pipe <= addb_pipe;
    end
end

// Calculate the sum values for each pipeline stage
wire [64:0] sum;
assign sum = {1'b0, adda_pipe} + {1'b0, addb_pipe};

// Update the output enable signal based on the pipeline stages
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en_pipe <= 1'b0;
    end else if (i_en_pipe) begin
        o_en_pipe <= 1'b1;
    end else begin
        o_en_pipe <= 1'b0;
    end
end

// Assign the output values
assign result = sum;
assign o_en = o_en_pipe;

endmodule