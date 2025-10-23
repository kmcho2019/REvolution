module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg i_en_reg;
reg [63:0] sum_reg;
reg o_en_reg;

// Combinational logic to calculate sum and carry
wire [64:0] sum_wire;
assign sum_wire = adda_reg + addb_reg;

// Sequential logic for reset, input registration, and output enable update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        i_en_reg <= 1'b0;
        sum_reg <= 64'd0;
        o_en_reg <= 1'b0;
    end else begin
        adda_reg <= adda;
        addb_reg <= addb;
        i_en_reg <= i_en;
        if (i_en_reg) begin
            sum_reg <= sum_wire[63:0];
            o_en_reg <= 1'b1;
        end else begin
            sum_reg <= 64'd0;
            o_en_reg <= 1'b0;
        end
    end
end

// Combinational logic for final result
assign result = {1'b0, sum_reg} + {64{(sum_wire[64])}};

// Output enable signal
assign o_en = o_en_reg;

endmodule