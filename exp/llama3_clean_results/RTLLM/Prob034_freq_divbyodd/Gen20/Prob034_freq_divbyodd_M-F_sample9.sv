module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

logic [$clog2(NUM_DIV-1):0] cnt1; // counter for rising edge
logic [$clog2(NUM_DIV-1):0] cnt2; // counter for falling edge
logic clk_div1; // divided clock for rising edge
logic clk_div2; // divided clock for falling edge
logic prev_clk; // previous clock value

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
        prev_clk <= 1'b0;
    end else begin
        prev_clk <= clk;
        if (clk == 1'b1 && prev_clk == 1'b0) begin // Rising edge
            if (cnt1 == (NUM_DIV / 2)) begin // toggle at half of NUM_DIV
                cnt1 <= 0;
                clk_div1 <= ~clk_div1;
            end else begin
                cnt1 <= cnt1 + 1;
            end
        end else if (clk == 1'b0 && prev_clk == 1'b1) begin // Falling edge
            if (cnt2 == (NUM_DIV / 2)) begin // toggle at half of NUM_DIV
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;
            end else begin
                cnt2 <= cnt2 + 1;
            end
        end
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule