module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 4  // CLA stage width
) (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [DATA_WIDTH-1:0] adda,
    input wire [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result,
    output reg o_en
);

// Pipeline registers
reg [DATA_WIDTH-1:0] stage1_a, stage1_b;
reg [STG_WIDTH-1:0] cla_a, cla_b;
reg [DATA_WIDTH-STG_WIDTH-1:0] rc_a, rc_b;
reg en1, en2;

// Carry signals
reg cla_carry_out;
reg [DATA_WIDTH/STG_WIDTH:0] carry_chain;

// Generate propagate and carry for CLA
wire [STG_WIDTH-1:0] p = stage1_a[STG_WIDTH-1:0] | stage1_b[STG_WIDTH-1:0];
wire [STG_WIDTH-1:0] g = stage1_a[STG_WIDTH-1:0] & stage1_b[STG_WIDTH-1:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        stage1_a <= 0;
        stage1_b <= 0;
        cla_a <= 0;
        cla_b <= 0;
        rc_a <= 0;
        rc_b <= 0;
        en1 <= 0;
        en2 <= 0;
        result <= 0;
        o_en <= 0;
        cla_carry_out <= 0;
        carry_chain <= 0;
    end else begin
        // Pipeline Stage 1: Register inputs and calculate CLA
        stage1_a <= adda;
        stage1_b <= addb;
        en1 <= i_en;
        
        // Calculate CLA carry
        cla_carry_out <= g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | 
                        (p[3] & p[2] & p[1] & g[0]);
        
        // Store remaining bits for ripple carry
        rc_a <= adda[DATA_WIDTH-1:STG_WIDTH];
        rc_b <= addb[DATA_WIDTH-1:STG_WIDTH];
        
        // Pipeline Stage 2: Ripple carry and result assembly
        en2 <= en1;
        o_en <= en2;
        
        if (en2) begin
            // CLA result (first 4 bits)
            result[STG_WIDTH-1:0] <= stage1_a[STG_WIDTH-1:0] + stage1_b[STG_WIDTH-1:0];
            
            // Initialize ripple carry with CLA carry
            carry_chain[0] <= cla_carry_out;
            
            // Ripple carry through remaining bits
            for (integer i = 0; i < DATA_WIDTH-STG_WIDTH; i = i + 1) begin
                {carry_chain[i+1], result[STG_WIDTH+i]} = 
                    rc_a[i] + rc_b[i] + carry_chain[i];
            end
            
            // Final carry out
            result[DATA_WIDTH] <= carry_chain[DATA_WIDTH-STG_WIDTH];
        end else begin
            result <= 0;
        end
    end
end

endmodule