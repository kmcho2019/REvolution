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

localparam HALF_DIV = (NUM_DIV - 1)/2;

// Positive edge domain
reg [31:0] cnt_pos;
reg clk_div_pos;

// Negative edge domain
reg [31:0] cnt_neg;
reg clk_div_neg;

// Output generation - XOR ensures proper phase alignment
assign clk_div = clk_div_pos ^ clk_div_neg;

// Positive edge counter and toggle
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_pos <= 0;
        clk_div_pos <= 0;
    end else begin
        cnt_pos <= (cnt_pos == NUM_DIV - 1) ? 0 : cnt_pos + 1;
        
        // Toggle at half period (rising edge)
        if (cnt_pos == HALF_DIV - 1) begin
            clk_div_pos <= ~clk_div_pos;
        end
    end
end

// Negative edge counter and toggle
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_neg <= 0;
        clk_div_neg <= 0;
    end else begin
        cnt_neg <= (cnt_neg == NUM_DIV - 1) ? 0 : cnt_neg + 1;
        
        // Toggle at half period (falling edge)
        if (cnt_neg == HALF_DIV - 1) begin
            clk_div_neg <= ~clk_div_neg;
        end
    end
end

endmodule