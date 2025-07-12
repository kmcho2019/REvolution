module freq_divbyodd (
    input  clk,
    input  rst_n,
    output reg clk_div
);

parameter NUM_DIV = 5; // default divisor value

reg [2:0] cnt1; // counter for positive edge
reg [2:0] cnt2; // counter for negative edge
reg clk_div1;   // divided clock for positive edge
reg clk_div2;   // divided clock for negative edge
reg prev_clk;   // previous clock value for edge detection

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // reset condition
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
        prev_clk <= 1'b0;
    end else begin
        // detect rising edge
        if (clk && !prev_clk) begin
            cnt1 <= cnt1 + 1;
            if (cnt1 == (NUM_DIV - 1) / 2) begin
                clk_div1 <= ~clk_div1;
            end
        end
        
        // detect falling edge
        if (!clk && prev_clk) begin
            cnt2 <= cnt2 + 1;
            if (cnt2 == (NUM_DIV - 1) / 2) begin
                clk_div2 <= ~clk_div2;
            end
        end
        
        prev_clk <= clk;
        
        // reset counters after reaching NUM_DIV - 1
        if (cnt1 == (NUM_DIV - 1)) begin
            cnt1 <= 0;
        end
        if (cnt2 == (NUM_DIV - 1)) begin
            cnt2 <= 0;
        end
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule