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
reg [1:0] en_pipe;

// Combinational addition
wire [64:0] sum = {1'b0, a_reg} + {1'b0, b_reg};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        a_reg <= 64'b0;
        b_reg <= 64'b0;
        en_pipe <= 2'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 1: Input registration
        a_reg <= adda;
        b_reg <= addb;
        
        // Pipeline the enable signal
        en_pipe <= {en_pipe[0], i_en};
        
        // Stage 2: Perform addition and register result
        if (en_pipe[0]) begin
            result <= sum;
        end
        
        // Output enable follows final pipeline stage
        o_en <= en_pipe[1];
    end
end

endmodule