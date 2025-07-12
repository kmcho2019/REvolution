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
reg [63:0] reg_a;
reg [63:0] reg_b;
reg        reg_en;

// Combinational sum
wire [64:0] sum = {1'b0, reg_a} + {1'b0, reg_b};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        reg_a <= 64'b0;
        reg_b <= 64'b0;
        reg_en <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Register inputs
        reg_a <= adda;
        reg_b <= addb;
        reg_en <= i_en;
        
        // Register output
        result <= sum;
        o_en <= reg_en;
    end
end

endmodule