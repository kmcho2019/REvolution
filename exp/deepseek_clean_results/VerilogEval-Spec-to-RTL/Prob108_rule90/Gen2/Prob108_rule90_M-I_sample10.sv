module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

// Pipeline registers
reg [511:0] q_stage1;
wire [511:0] next_q;

// Clock gating control
wire update_en = load || (|(q ^ q_stage1));  // Update only if load or state changed

// First pipeline stage: calculate even indices
genvar i;
generate
    for (i = 0; i < 512; i = i + 2) begin : even_cells
        assign next_q[i] = (i == 0) ? (0 ^ q[1]) : 
                         (i == 511) ? (q[510] ^ 0) : 
                         (q[i-1] ^ q[i+1]);
    end
    for (i = 1; i < 512; i = i + 2) begin : odd_cells
        assign next_q[i] = (i == 511) ? (q[510] ^ 0) : 
                         (q[i-1] ^ q[i+1]);
    end
endgenerate

// Pipeline stage 1
always @(posedge clk) begin
    if (load) begin
        q_stage1 <= data;
    end else if (update_en) begin
        q_stage1 <= next_q;
    end
end

// Final output stage
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (update_en) begin
        q <= q_stage1;
    end
end

endmodule