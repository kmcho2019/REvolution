module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Input registers
reg [63:0] adda_reg, addb_reg;
reg enable_reg;

// Combinational sum
wire [64:0] sum = {1'b0, adda_reg} + {1'b0, addb_reg};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg <= 64'b0;
        addb_reg <= 64'b0;
        enable_reg <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Register inputs and enable
        adda_reg <= adda;
        addb_reg <= addb;
        enable_reg <= i_en;
        
        // Register output
        result <= sum;
        o_en <= enable_reg;
    end
end

endmodule