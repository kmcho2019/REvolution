module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [511:0] stage1_q;
    reg [511:0] stage2_q;
    reg load_pipe;

    // Clock gating logic
    wire compute_en = ~load;

    // Pipeline stage 1: Compute left and right neighbors
    always @(posedge clk) begin
        if (compute_en) begin
            for (integer i = 0; i < 512; i = i + 1) begin
                // Boundary conditions: q[-1] = 0, q[512] = 0
                reg left = (i == 511) ? 1'b0 : q[i+1];
                reg right = (i == 0) ? 1'b0 : q[i-1];
                // Store intermediate results
                stage1_q[i] <= {left, q[i], right};
            end
            load_pipe <= 1'b0;
        end else begin
            load_pipe <= 1'b1;
        end
    end

    // Pipeline stage 2: Apply Rule 110
    always @(posedge clk) begin
        if (load_pipe) begin
            q <= data;
        end else begin
            for (integer i = 0; i < 512; i = i + 1) begin
                // Apply optimized Rule 110 logic
                case (stage1_q[i])
                    3'b111: q[i] <= 1'b0;
                    3'b110, 3'b101, 3'b011, 3'b010, 3'b001: q[i] <= 1'b1;
                    default: q[i] <= 1'b0;
                endcase
            end
        end
    end

endmodule