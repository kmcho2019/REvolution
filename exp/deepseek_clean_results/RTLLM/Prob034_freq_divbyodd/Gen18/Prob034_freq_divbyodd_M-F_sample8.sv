module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameter validation (synthesis-compatible)
generate
    if (NUM_DIV % 2 == 0) begin
        illegal_parameter_odd_number odd_number_check();
    end
endgenerate

localparam HALF_DIV = (NUM_DIV - 1)/2;
reg [31:0] cnt1, cnt2;  // Counters for posedge and negedge
reg clk_div1, clk_div2; // Intermediate clock signals

// Positive edge counter and clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt1 <= 0;
        clk_div1 <= 0;
    end else begin
        if (cnt1 == NUM_DIV - 1) begin
            cnt1 <= 0;
            clk_div1 <= 1'b0;
        end else begin
            cnt1 <= cnt1 + 1;
            if (cnt1 == HALF_DIV) begin
                clk_div1 <= 1'b1;
            end
        end
    end
end

// Negative edge counter and clock
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt2 <= 0;
        clk_div2 <= 0;
    end else begin
        if (cnt2 == NUM_DIV - 1) begin
            cnt2 <= 0;
            clk_div2 <= 1'b0;
        end else begin
            cnt2 <= cnt2 + 1;
            if (cnt2 == HALF_DIV) begin
                clk_div2 <= 1'b1;
            end
        end
    end
end

// Combine both clocks
assign clk_div = clk_div1 | clk_div2;

endmodule