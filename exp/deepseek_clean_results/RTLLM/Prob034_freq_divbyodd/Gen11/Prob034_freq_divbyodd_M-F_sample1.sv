module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    // Validate parameter (NUM_DIV must be odd and >= 3)
    initial begin
        if (NUM_DIV < 3 || NUM_DIV[0] == 0) begin
            $error("NUM_DIV must be an odd number >= 3");
            $finish;
        end
    end

    localparam COUNTER_WIDTH = $clog2(NUM_DIV);
    localparam MID_POINT = (NUM_DIV - 1) / 2;

    reg [COUNTER_WIDTH-1:0] cnt1, cnt2;
    reg clk_div1, clk_div2;

    // Rising edge counter (positive phase)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
            end else begin
                cnt1 <= cnt1 + 1;
            end
            
            if (cnt1 == MID_POINT - 1) begin
                clk_div1 <= 1;
            end else if (cnt1 == NUM_DIV - 1) begin
                clk_div1 <= 0;
            end
        end
    end

    // Falling edge counter (negative phase)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= MID_POINT;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
            end else begin
                cnt2 <= cnt2 + 1;
            end
            
            if (cnt2 == MID_POINT - 1) begin
                clk_div2 <= 1;
            end else if (cnt2 == NUM_DIV - 1) begin
                clk_div2 <= 0;
            end
        end
    end

    // Combine both phases with XOR for proper edge alignment
    assign clk_div = clk_div1 ^ clk_div2;

endmodule