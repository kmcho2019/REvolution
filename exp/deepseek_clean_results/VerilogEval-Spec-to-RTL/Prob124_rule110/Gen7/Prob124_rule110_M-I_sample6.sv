module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipelined implementation with 8 stages (64 bits per stage)
    reg [511:0] stage [0:7];
    wire [511:0] next_stage [0:7];
    wire load_gated_clk;
    integer i, j;

    // Clock gating for power reduction
    assign load_gated_clk = clk & ~load;

    // Simplified Rule 110 logic using Boolean equations
    function automatic rule110;
        input left, center, right;
        begin
            rule110 = (center & (left | right)) | (~center & right);
        end
    endfunction

    // Generate pipeline stages
    generate
        for (genvar s = 0; s < 8; s = s + 1) begin : pipeline
            // Compute next state for current stage (64 bits)
            always @(*) begin
                for (int i = 0; i < 64; i = i + 1) begin
                    integer idx = s*64 + i;
                    wire left = (idx == 0) ? 1'b0 : ((idx == 511) ? stage[s][idx-1] : q[idx-1]);
                    wire right = (idx == 511) ? 1'b0 : ((idx == 0) ? stage[s][idx+1] : q[idx+1]);
                    next_stage[s][idx] = rule110(left, q[idx], right);
                end
            end

            // Pipeline registers with clock gating
            always @(posedge load_gated_clk) begin
                if (s == 0) begin
                    stage[s] <= next_stage[s];
                end else begin
                    stage[s] <= stage[s-1];
                end
            end
        end
    endgenerate

    // Main register update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= stage[7];  // Final pipeline stage
        end
    end

endmodule