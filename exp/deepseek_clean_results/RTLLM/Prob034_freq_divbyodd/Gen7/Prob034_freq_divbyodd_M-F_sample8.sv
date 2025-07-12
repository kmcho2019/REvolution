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
reg clk_div1;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_pos <= 0;
        clk_div1 <= 0;
    end
    else begin
        if (cnt_pos == NUM_DIV - 1) begin
            cnt_pos <= 0;
            clk_div1 <= ~clk_div1;
        end
        else begin
            cnt_pos <= cnt_pos + 1;
            if (cnt_pos == HALF_DIV - 1) begin
                clk_div1 <= ~clk_div1;
            end
        end
    end
end

// Negative edge domain
reg [31:0] cnt_neg;
reg clk_div2;
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_neg <= 0;
        clk_div2 <= 0;
    end
    else begin
        if (cnt_neg == NUM_DIV - 1) begin
            cnt_neg <= 0;
            clk_div2 <= ~clk_div2;
        end
        else begin
            cnt_neg <= cnt_neg + 1;
            if (cnt_neg == HALF_DIV - 1) begin
                clk_div2 <= ~clk_div2;
            end
        end
    end
end

// Output generation
assign clk_div = clk_div1 | clk_div2;

endmodule