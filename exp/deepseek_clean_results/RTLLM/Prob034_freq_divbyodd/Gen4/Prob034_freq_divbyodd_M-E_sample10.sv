module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    localparam CNT_WIDTH = $clog2(NUM_DIV);
    localparam TOGGLE_POINT = (NUM_DIV - 1) / 2;
    
    reg [CNT_WIDTH:0] phase_cnt;
    reg phase_dir;  // 0=counting up, 1=counting down
    
    always @(posedge clk or negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            phase_cnt <= 0;
            phase_dir <= 0;
            clk_div <= 0;
        end
        else begin
            // Update phase counter with direction
            if (phase_dir) begin
                phase_cnt <= (phase_cnt == 0) ? 1 : phase_cnt - 1;
                if (phase_cnt == 0) phase_dir <= 0;
            end
            else begin
                phase_cnt <= (phase_cnt == NUM_DIV-1) ? NUM_DIV-2 : phase_cnt + 1;
                if (phase_cnt == NUM_DIV-1) phase_dir <= 1;
            end
            
            // Toggle output at calculated points
            if ((!phase_dir && phase_cnt == TOGGLE_POINT) ||
                (phase_dir && phase_cnt == TOGGLE_POINT+1)) begin
                clk_div <= ~clk_div;
            end
        end
    end

endmodule