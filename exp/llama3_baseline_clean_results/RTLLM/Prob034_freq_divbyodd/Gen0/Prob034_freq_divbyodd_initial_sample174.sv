module freq_divbyodd(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 5; // default divisor value

reg [3:0] cnt1; // counter for rising edge
reg [3:0] cnt2; // counter for falling edge
reg clk_div1; // divided clock for positive edge
reg clk_div2; // divided clock for negative edge

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin // reset condition
        cnt1 <= 4'b0;
        cnt2 <= 4'b0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        if (cnt1 == (NUM_DIV / 2) - 1) begin // half of NUM_DIV for rising edge
            clk_div1 <= ~clk_div1;
            cnt1 <= 4'b0;
        end else begin
            cnt1 <= cnt1 + 1;
        end
        
        if (cnt2 == (NUM_DIV / 2) - 1) begin // half of NUM_DIV for falling edge
            clk_div2 <= ~clk_div2;
            cnt2 <= 4'b0;
        end else if (cnt2 != 0) begin // count only when not resetting cnt2
            cnt2 <= cnt2 + 1;
        end else if (clk_div1 != clk_div2) begin // sync cnt2 with cnt1
            cnt2 <= 1;
        end
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule