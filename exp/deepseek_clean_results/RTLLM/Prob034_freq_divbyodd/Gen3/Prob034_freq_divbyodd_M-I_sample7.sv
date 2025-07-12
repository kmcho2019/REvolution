module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// Compile-time check for odd number
generate
    if (NUM_DIV % 2 == 0) begin
        initial begin
            $error("NUM_DIV must be an odd number");
            $finish;
        end
    end
endgenerate

localparam HALF_DIV = (NUM_DIV - 1)/2;
reg [31:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end
    else begin
        if (cnt == NUM_DIV - 1) begin
            cnt <= 0;
            clk_div <= ~clk_div;  // Toggle at full period
        end
        else begin
            cnt <= cnt + 1;
            // Additional toggle at half period for 50% duty cycle
            if (cnt == HALF_DIV - 1) begin
                clk_div <= ~clk_div;
            end
        end
    end
end

endmodule