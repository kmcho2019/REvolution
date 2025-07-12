module freq_divbyodd #(
    parameter NUM_DIV = 5  // default odd divisor value
)(
    input  wire         clk,    // input clock signal
    input  wire         rst_n,  // active low reset signal
    output wire         clk_div // divided clock output
);

reg [2:0] cnt1;  // counter for rising edge
reg [2:0] cnt2;  // counter for falling edge
reg       clk_div1;  // divided clock for positive edge
reg       clk_div2;  // divided clock for negative edge

// calculate half of NUM_DIV
localparam HALF_DIV = (NUM_DIV - 1) / 2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // active low reset
        cnt1  <= '0;
        cnt2  <= '0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        if (cnt1 == NUM_DIV - 1) begin  // reset cnt1
            cnt1  <= '0;
            if (cnt2 == HALF_DIV) begin
                clk_div1 <= ~clk_div1;  // toggle clk_div1
            end
        end else begin
            cnt1  <= cnt1 + 1'b1;
        end
        
        if (cnt2 == NUM_DIV - 1) begin  // reset cnt2
            cnt2  <= '0;
            if (cnt1 == HALF_DIV) begin
                clk_div2 <= ~clk_div2;  // toggle clk_div2
            end
        end else begin
            cnt2  <= cnt2 + 1'b1;
        end
    end
end

// derive final divided clock output by logically OR-ing clk_div1 and clk_div2
assign clk_div = clk_div1 | clk_div2;

endmodule