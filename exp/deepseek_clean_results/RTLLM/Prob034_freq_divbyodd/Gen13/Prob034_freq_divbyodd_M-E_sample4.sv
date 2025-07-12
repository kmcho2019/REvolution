module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    localparam CNT_WIDTH = $clog2(NUM_DIV);
    localparam HIGH_PHASE = (NUM_DIV + 1)/2;
    localparam LOW_PHASE = (NUM_DIV - 1)/2;

    reg [CNT_WIDTH-1:0] main_cnt;
    reg [CNT_WIDTH-1:0] phase_cnt;
    reg phase_select;

    // Main counter (positive edge domain)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            main_cnt <= 0;
            phase_select <= 0;
        end else begin
            if (main_cnt == NUM_DIV-1) begin
                main_cnt <= 0;
                phase_select <= ~phase_select;
            end else begin
                main_cnt <= main_cnt + 1;
            end
        end
    end

    // Phase counter (negative edge domain)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            phase_cnt <= 0;
        end else begin
            if (phase_cnt == NUM_DIV-1) begin
                phase_cnt <= 0;
            end else begin
                phase_cnt <= phase_cnt + 1;
            end
        end
    end

    // Output generation with phase-aware control
    always @(*) begin
        if (phase_select) begin
            // First phase: main counter controls rising edge
            clk_div = (main_cnt < HIGH_PHASE) ? 1'b1 : 1'b0;
        end else begin
            // Second phase: phase counter controls falling edge
            clk_div = (phase_cnt < LOW_PHASE) ? 1'b0 : 1'b1;
        end
    end

endmodule