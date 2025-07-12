module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Asymmetric pipeline stage widths
localparam STAGE0_WIDTH = 24;  // CLA stage
localparam STAGE1_WIDTH = 16;  // Ripple stage
localparam STAGE2_WIDTH = 16;  // Ripple stage
localparam STAGE3_WIDTH = 8;   // Final stage

// Pipeline registers
reg [63:0] a_pipe [0:3];
reg [63:0] b_pipe [0:3];
reg [3:0] en_pipe;
reg [3:0] carry_pipe;

// CLA generation for first stage
wire [STAGE0_WIDTH:0] cla_sum;
wire cla_carry_out;

// CLA block for first 24 bits
cla_24bit cla_block (
    .a(adda[STAGE0_WIDTH-1:0]),
    .b(addb[STAGE0_WIDTH-1:0]),
    .cin(1'b0),
    .sum(cla_sum[STAGE0_WIDTH-1:0]),
    .cout(cla_carry_out)
);
assign cla_sum[STAGE0_WIDTH] = cla_carry_out;

// Ripple stages
wire [STAGE1_WIDTH:0] ripple1_sum;
wire [STAGE2_WIDTH:0] ripple2_sum;
wire [STAGE3_WIDTH:0] ripple3_sum;

assign ripple1_sum = {1'b0, a_pipe[0][STAGE0_WIDTH +: STAGE1_WIDTH]} + 
                    {1'b0, b_pipe[0][STAGE0_WIDTH +: STAGE1_WIDTH]} + 
                    carry_pipe[0];
                    
assign ripple2_sum = {1'b0, a_pipe[1][STAGE0_WIDTH+STAGE1_WIDTH +: STAGE2_WIDTH]} + 
                    {1'b0, b_pipe[1][STAGE0_WIDTH+STAGE1_WIDTH +: STAGE2_WIDTH]} + 
                    carry_pipe[1];
                    
assign ripple3_sum = {1'b0, a_pipe[2][STAGE0_WIDTH+STAGE1_WIDTH+STAGE2_WIDTH +: STAGE3_WIDTH]} + 
                    {1'b0, b_pipe[2][STAGE0_WIDTH+STAGE1_WIDTH+STAGE2_WIDTH +: STAGE3_WIDTH]} + 
                    carry_pipe[2];

// Pipeline processing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear pipeline
        for (integer i = 0; i < 4; i = i + 1) begin
            a_pipe[i] <= 64'b0;
            b_pipe[i] <= 64'b0;
        end
        en_pipe <= 4'b0;
        carry_pipe <= 4'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Shift enable through dedicated path
        en_pipe <= {en_pipe[2:0], i_en};
        
        // Stage 0: Register inputs and CLA result
        a_pipe[0] <= adda;
        b_pipe[0] <= addb;
        carry_pipe[0] <= cla_carry_out;
        
        // Stage 1: First ripple stage
        a_pipe[1] <= a_pipe[0];
        b_pipe[1] <= b_pipe[0];
        carry_pipe[1] <= ripple1_sum[STAGE1_WIDTH];
        
        // Stage 2: Second ripple stage
        a_pipe[2] <= a_pipe[1];
        b_pipe[2] <= b_pipe[1];
        carry_pipe[2] <= ripple2_sum[STAGE2_WIDTH];
        
        // Stage 3: Final stage
        a_pipe[3] <= a_pipe[2];
        b_pipe[3] <= b_pipe[2];
        carry_pipe[3] <= ripple3_sum[STAGE3_WIDTH];
        
        // Output assembly
        if (en_pipe[3]) begin
            result <= {
                ripple3_sum[STAGE3_WIDTH],  // Final carry
                ripple3_sum[STAGE3_WIDTH-1:0],
                ripple2_sum[STAGE2_WIDTH-1:0],
                ripple1_sum[STAGE1_WIDTH-1:0],
                cla_sum[STAGE0_WIDTH-1:0]
            };
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule

// 24-bit Carry Lookahead Adder submodule
module cla_24bit (
    input wire [23:0] a,
    input wire [23:0] b,
    input wire cin,
    output wire [23:0] sum,
    output wire cout
);
    wire [23:0] g, p;
    wire [24:0] c;
    
    assign c[0] = cin;
    
    // Generate and propagate
    assign g = a & b;
    assign p = a ^ b;
    
    // Carry lookahead
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    
    // Block carry lookahead (4 groups of 6 bits)
    genvar i;
    for (i = 4; i <= 24; i = i + 1) begin : cla_gen
        assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
    end
    
    // Sum calculation
    assign sum = p ^ c[23:0];
    assign cout = c[24];
endmodule