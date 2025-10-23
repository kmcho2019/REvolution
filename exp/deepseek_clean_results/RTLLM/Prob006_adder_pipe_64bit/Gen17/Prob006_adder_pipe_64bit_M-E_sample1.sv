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
reg [7:0] a [0:7], b [0:7];  // 8 stages of 8-bit operands
reg [7:0] sum [0:7];          // 8-bit partial sums
reg carry [0:7];              // Carry between stages
reg [7:0] en_pipe;            // Enable pipeline

// Carry-skip signals
wire skip [0:7];              // Carry-skip conditions

// Generate carry-skip conditions
genvar i;
generate
    for (i=0; i<8; i=i+1) begin : skip_gen
        assign skip[i] = &(a[i] | b[i]);  // All bits propagate carry
    end
endgenerate

// Pipeline processing
integer stg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (stg=0; stg<8; stg=stg+1) begin
            a[stg] <= 8'b0;
            b[stg] <= 8'b0;
            sum[stg] <= 8'b0;
            carry[stg] <= 1'b0;
            en_pipe[stg] <= 1'b0;
        end
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 0: Process bits [7:0]
        a[0] <= adda[7:0];
        b[0] <= addb[7:0];
        {carry[0], sum[0]} <= a[0] + b[0];
        en_pipe[0] <= i_en;

        // Stages 1-7: Process remaining bits with carry-skip
        for (stg=1; stg<8; stg=stg+1) begin
            a[stg] <= adda[8*stg+7 : 8*stg];
            b[stg] <= addb[8*stg+7 : 8*stg];
            
            if (skip[stg-1] && carry[stg-1]) begin
                // Skip carry propagation when possible
                {carry[stg], sum[stg]} <= a[stg] + b[stg] + 1'b1;
            end else begin
                // Normal ripple-carry case
                {carry[stg], sum[stg]} <= a[stg] + b[stg] + carry[stg-1];
            end
            
            en_pipe[stg] <= en_pipe[stg-1];
        end

        // Final result assembly
        result <= {carry[7], 
                  sum[7], sum[6], sum[5], sum[4], 
                  sum[3], sum[2], sum[1], sum[0]};
        o_en <= en_pipe[7];
    end
end

endmodule