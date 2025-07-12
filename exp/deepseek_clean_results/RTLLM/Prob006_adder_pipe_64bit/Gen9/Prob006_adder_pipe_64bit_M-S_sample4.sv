module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Single pipeline register for enable signal
reg i_en_reg;

// Full 64-bit addition (combinational)
wire [64:0] sum = {1'b0, adda} + {1'b0, addb};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
        i_en_reg <= 1'b0;
    end else begin
        i_en_reg <= i_en;
        if (i_en) begin
            result <= sum;
        end
        o_en <= i_en_reg;
    end
end

endmodule