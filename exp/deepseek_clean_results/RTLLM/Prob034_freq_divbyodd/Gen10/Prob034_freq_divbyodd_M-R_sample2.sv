module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Check if NUM_DIV is odd
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam HALF_DIV = (NUM_DIV - 1) / 2;

// Positive edge domain
reg [31:0] cnt_pos;
wire pos_toggle = (cnt_pos == HALF_DIV) || (cnt_pos == NUM_DIV - 1);
reg clk_div_pos;

assign clk_div_pos = (pos_toggle) ? ~clk_div_pos : clk_div_pos;
assign cnt_pos = (!rst_n) ? 0 : 
                (cnt_pos == NUM_DIV - 1) ? 0 : cnt_pos + 1;

// Negative edge domain
reg [31:0] cnt_neg;
wire neg_toggle = (cnt_neg == HALF_DIV) || (cnt_neg == NUM_DIV - 1);
reg clk_div_neg;

assign clk_div_neg = (neg_toggle) ? ~clk_div_neg : clk_div_neg;
assign cnt_neg = (!rst_n) ? 0 : 
                (cnt_neg == NUM_DIV - 1) ? 0 : cnt_neg + 1;

// Output generation - OR both edge domains as specified
assign clk_div = clk_div_pos | clk_div_neg;

// Clock edge triggers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_pos <= 0;
    end else begin
        clk_div_pos <= (pos_toggle) ? ~clk_div_pos : clk_div_pos;
    end
end

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_neg <= 0;
    end else begin
        clk_div_neg <= (neg_toggle) ? ~clk_div_neg : clk_div_neg;
    end
end

endmodule