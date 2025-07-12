module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers
reg [63:0] a_reg, b_reg;
reg en_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        a_reg <= 64'b0;
        b_reg <= 64'b0;
        en_reg <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Register inputs and enable
        a_reg <= adda;
        b_reg <= addb;
        en_reg <= i_en;

        // Compute result in one cycle
        result <= {1'b0, a_reg} + {1'b0, b_reg};
        
        // Output enable follows registered enable
        o_en <= en_reg;
    end
end

endmodule