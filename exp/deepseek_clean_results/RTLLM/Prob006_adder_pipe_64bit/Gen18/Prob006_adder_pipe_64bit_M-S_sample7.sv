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
reg carry_in;
reg [1:0] en_pipe;

// Combinational adder
wire [64:0] sum = {1'b0, a_reg} + {1'b0, b_reg} + carry_in;

// Pipeline processing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all registers
        a_reg <= 64'b0;
        b_reg <= 64'b0;
        carry_in <= 1'b0;
        en_pipe <= 2'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Shift enable through pipeline
        en_pipe <= {en_pipe[0], i_en};
        
        // Stage 1: Register inputs
        a_reg <= adda;
        b_reg <= addb;
        carry_in <= 1'b0;  // Initial carry-in
        
        // Stage 2: Register result
        if (en_pipe[0]) begin
            result <= sum;
            o_en <= en_pipe[1];
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule