module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    localparam CNT_WIDTH = $clog2(NUM_DIV);
    localparam MID_POINT = (NUM_DIV-1)/2;
    
    reg [CNT_WIDTH-1:0] cnt;
    reg clk_phase1, clk_phase2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_phase1 <= 0;
            clk_phase2 <= 0;
        end
        else begin
            if (cnt == NUM_DIV-1) begin
                cnt <= 0;
                clk_phase1 <= ~clk_phase1;
            end
            else begin
                cnt <= cnt + 1;
            end
            
            if (cnt == MID_POINT) begin
                clk_phase2 <= ~clk_phase2;
            end
        end
    end

    assign clk_div = clk_phase1 | clk_phase2;

endmodule