module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [511:0] q_stage1;
    reg left_boundary, right_boundary;
    
    // Clock gating signals
    wire boundary_clk_en = load | (|q[510:0]) | (|q[511:1]);
    wire boundary_clk = boundary_clk_en & clk;
    
    // Stage 1: Boundary precomputation
    always @(posedge boundary_clk) begin
        left_boundary <= 1'b0;
        right_boundary <= 1'b0;
        if (load) begin
            q_stage1 <= data;
        end else begin
            q_stage1 <= q;
        end
    end
    
    // Stage 2: Main computation with precomputed boundaries
    wire [511:0] next_q;
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin: rule90
            wire left = (i == 0) ? left_boundary : q_stage1[i-1];
            wire right = (i == 511) ? right_boundary : q_stage1[i+1];
            assign next_q[i] = left ^ right;
        end
    endgenerate
    
    // Final output register
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule