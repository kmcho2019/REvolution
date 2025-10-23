module freq_divbyodd #(
    parameter NUM_DIV = 5  // Default divisor value, must be odd
) (
    input  clk,           // Input clock signal
    input  rst_n,         // Active low reset signal
    output reg clk_div    // Divided clock output
);

reg [2:0] cnt1;  // Counter for tracking rising edges
reg [2:0] cnt2;  // Counter for tracking falling edges
reg clk_div1;    // Clock divider for positive edges
reg clk_div2;    // Clock divider for positive edges

// Calculate the half value of NUM_DIV for toggling the clock dividers
localparam HALF_DIV = NUM_DIV / 2;

// Handle the case when NUM_DIV is not odd
initial begin
    if (NUM_DIV % 2 == 0) begin
        $display("Error: NUM_DIV must be an odd number.");
        $finish;
    end
end

always @(*) begin
    if (~rst_n) begin  // Active low reset
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        if (clk) begin  // Rising edge
            if (cnt1 == (NUM_DIV - 1)) begin
                cnt1 <= 0;
                clk_div1 <= ~clk_div1;
            end else begin
                cnt1 <= cnt1 + 1;
            end
        end else begin  // Falling edge
            if (cnt2 == (NUM_DIV - 1)) begin
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;
            end else begin
                cnt2 <= cnt2 + 1;
            end
        end
    end
end

// Derive the final divided clock output by logically OR-ing clk_div1 and clk_div2
always @(*) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        if ((cnt1 == HALF_DIV) && (clk_div1 == 1'b1)) begin
            clk_div <= 1'b1;
        end else if ((cnt2 == HALF_DIV) && (clk_div2 == 1'b1)) begin
            clk_div <= 1'b1;
        end else begin
            clk_div <= 1'b0;
        end
    end
end

endmodule