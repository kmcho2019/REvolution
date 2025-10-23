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
reg [31:0] sum_low, sum_mid;
reg [15:0] sum_high;
reg carry_low, carry_mid;
reg [2:0] en_pipe;

// Internal signals
wire [32:0] seg_low;
wire [32:0] seg_mid;
wire [16:0] seg_high;

// Segment 0 (bits 0-31)
assign seg_low = {1'b0, adda[31:0]} + {1'b0, addb[31:0]};

// Segment 1 (bits 32-47)
assign seg_mid = {1'b0, adda[47:32]} + {1'b0, addb[47:32]} + carry_low;

// Segment 2 (bits 48-63)
assign seg_high = {1'b0, adda[63:48]} + {1'b0, addb[63:48]} + carry_mid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        sum_low <= 32'b0;
        sum_mid <= 32'b0;
        sum_high <= 16'b0;
        carry_low <= 1'b0;
        carry_mid <= 1'b0;
        en_pipe <= 3'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 0 (low 32 bits)
        sum_low <= seg_low[31:0];
        carry_low <= seg_low[32];
        en_pipe[0] <= i_en;
        
        // Pipeline stage 1 (middle 16 bits)
        sum_mid[15:0] <= seg_mid[15:0];
        carry_mid <= seg_mid[16];
        en_pipe[1] <= en_pipe[0];
        
        // Pipeline stage 2 (high 16 bits)
        sum_high <= seg_high[15:0];
        en_pipe[2] <= en_pipe[1];
        
        // Final output stage
        result <= {seg_high[16], sum_high, sum_mid[15:0], sum_low};
        o_en <= en_pipe[2];
    end
end

endmodule