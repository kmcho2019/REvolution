module square_wave #(
    parameter COUNTER_WIDTH = 8,
    parameter INIT_OUTPUT = 0,
    parameter CLOCK_GATING = 0
) (
    input clk,
    input reset_n,
    input [COUNTER_WIDTH-1:0] freq,
    output reg wave_out
);

    reg [COUNTER_WIDTH-1:0] count;
    reg [COUNTER_WIDTH-1:0] count_gray;
    wire [COUNTER_WIDTH-1:0] next_count;
    wire count_enable;
    reg compare_stage1, compare_stage2;

    // Clock gating control (optional)
    generate if (CLOCK_GATING) begin
        assign count_enable = (freq != 0);
    end else begin
        assign count_enable = 1'b1;
    end endgenerate

    // Gray code counter
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            count <= 0;
            count_gray <= 0;
            wave_out <= INIT_OUTPUT;
            compare_stage1 <= 0;
            compare_stage2 <= 0;
        end else if (count_enable) begin
            // Binary counter
            count <= next_count;
            
            // Gray code conversion
            count_gray <= next_count ^ (next_count >> 1);
            
            // Two-stage comparison pipeline
            compare_stage1 <= (count == freq);
            compare_stage2 <= compare_stage1;
            
            // Toggle output on second pipeline stage
            if (compare_stage2) begin
                wave_out <= ~wave_out;
            end
        end
    end

    assign next_count = (compare_stage2) ? 0 : (count + 1);

endmodule