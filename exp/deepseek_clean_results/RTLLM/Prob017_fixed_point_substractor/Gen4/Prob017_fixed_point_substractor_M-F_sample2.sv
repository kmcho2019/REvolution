module fixed_point_subtractor #(
    parameter Q = 16,          // Number of fractional bits
    parameter N = 32,          // Total number of bits
    parameter PIPELINE_STAGES = 1, // Number of pipeline stages
    parameter HANDLE_ZERO = 1   // Enable explicit zero handling
) (
    input wire clk,
    input wire reset_n,
    input wire enable,
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

// Pipeline registers
reg [N-1:0] pipeline [0:PIPELINE_STAGES-1];
integer i;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        // Reset pipeline
        for (i = 0; i < PIPELINE_STAGES; i = i + 1)
            pipeline[i] <= {N{1'b0}};
        c <= {N{1'b0}};
    end
    else if (enable) begin
        // First stage: perform subtraction
        pipeline[0] <= a - b;
        
        // Additional pipeline stages if needed
        for (i = 1; i < PIPELINE_STAGES; i = i + 1)
            pipeline[i] <= pipeline[i-1];
        
        // Final output with optional zero handling
        if (HANDLE_ZERO && (pipeline[PIPELINE_STAGES-1] == {N{1'b0}}))
            c <= {N{1'b0}};  // Force positive zero
        else
            c <= pipeline[PIPELINE_STAGES-1];
    end
end

endmodule