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
reg [63:0] a_reg1, a_reg2;
reg [63:0] b_reg1, b_reg2;
reg [64:0] sum_reg;
reg [2:0] en_shift;

// Combinational sum with carry
wire [64:0] sum = {1'b0, a_reg2} + {1'b0, b_reg2};

// Pipeline control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_reg1 <= 64'b0;
        a_reg2 <= 64'b0;
        b_reg1 <= 64'b0;
        b_reg2 <= 64'b0;
        sum_reg <= 65'b0;
        en_shift <= 3'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 1: Input registers
        a_reg1 <= adda;
        b_reg1 <= addb;
        
        // Stage 2: Computation registers
        a_reg2 <= a_reg1;
        b_reg2 <= b_reg1;
        sum_reg <= {1'b0, a_reg1} + {1'b0, b_reg1};
        
        // Stage 3: Output registers
        result <= sum;
        
        // Enable signal pipeline (3-stage shift register)
        en_shift <= {en_shift[1:0], i_en};
        o_en <= en_shift[2];
    end
end

endmodule