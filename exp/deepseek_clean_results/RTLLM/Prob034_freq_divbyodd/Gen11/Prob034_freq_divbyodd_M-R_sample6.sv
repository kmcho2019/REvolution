module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Verify parameter is odd
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

// Rising edge counter and clock
reg [31:0] cnt1;
reg clk_div1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt1 <= 0;
        clk_div1 <= 0;
    end
    else begin
        if (cnt1 == NUM_DIV - 1) begin
            cnt1 <= 0;
            clk_div1 <= ~clk_div1;
        end
        else begin
            cnt1 <= cnt1 + 1;
        end
    end
end

// Falling edge counter and clock
reg [31:0] cnt2;
reg clk_div2;

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt2 <= 0;
        clk_div2 <= 0;
    end
    else begin
        if (cnt2 == NUM_DIV - 1) begin
            cnt2 <= 0;
            clk_div2 <= ~clk_div2;
        end
        else begin
            cnt2 <= cnt2 + 1;
        end
    end
end

// Combine both clocks
assign clk_div = clk_div1 | clk_div2;

endmodule