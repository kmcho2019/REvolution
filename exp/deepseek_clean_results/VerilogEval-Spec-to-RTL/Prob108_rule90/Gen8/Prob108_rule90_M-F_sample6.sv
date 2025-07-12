module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

// Pipeline registers
reg [511:0] q_p1;

// Extended array with boundary conditions
wire [513:0] extended_q = {1'b0, q, 1'b0};

// Next state computation - broken into two stages
wire [511:0] next_q_stage1;
wire [511:0] next_q_stage2;

genvar i;
generate
    // First pipeline stage - compute XOR for even indices
    for (i = 0; i < 512; i = i + 2) begin : rule90_stage1
        assign next_q_stage1[i] = extended_q[i] ^ extended_q[i+2];
    end
    
    // Second pipeline stage - compute XOR for odd indices
    for (i = 1; i < 512; i = i + 2) begin : rule90_stage2
        assign next_q_stage2[i] = extended_q[i] ^ extended_q[i+2];
    end
endgenerate

// Combine pipeline stages
wire [511:0] next_q = next_q_stage1 | next_q_stage2;

// Sequential update with pipeline
always @(posedge clk) begin
    q_p1 <= load ? data : next_q;
    q <= q_p1;  // Additional pipeline stage
end

endmodule