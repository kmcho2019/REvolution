module freq_divbyodd #(
    parameter NUM_DIV = 5  // default divisor value
)(
    input  wire        clk,  // input clock signal
    input  wire        rst_n,  // active low reset signal
    output reg         clk_div  // divided clock output
);

reg [($clog2(NUM_DIV)-1):0] cnt1;  // counter for positive edges
reg [($clog2(NUM_DIV)-1):0] cnt2;  // counter for negative edges
reg                         clk_div1;  // divided clock for positive edges
reg                         clk_div2;  // divided clock for negative edges

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // reset condition
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
    end else begin
        if (cnt1 == (NUM_DIV - 1) / 2) begin  // toggle clk_div1 at half of NUM_DIV
            clk_div1 <= ~clk_div1;
        end
        if (cnt2 == (NUM_DIV - 1) / 2) begin  // toggle clk_div2 at half of NUM_DIV
            clk_div2 <= ~clk_div2;
        end
        cnt1 <= (cnt1 == (NUM_DIV - 1)) ? 0 : cnt1 + 1;  // increment cnt1
        cnt2 <= (cnt2 == (NUM_DIV - 1)) ? 0 : cnt2 + 1;  // increment cnt2
    end
end

// derive final divided clock output
assign clk_div = clk_div1 | clk_div2;

endmodule