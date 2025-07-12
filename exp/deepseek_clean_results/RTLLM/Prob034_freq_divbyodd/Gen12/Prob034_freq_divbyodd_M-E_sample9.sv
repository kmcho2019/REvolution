module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// Check if NUM_DIV is odd
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam HIGH_CYCLES = (NUM_DIV + 1) / 2;
localparam LOW_CYCLES = (NUM_DIV - 1) / 2;
localparam CNT_MAX = NUM_DIV - 1;

reg [31:0] counter;
wire counter_full = (counter == CNT_MAX);
wire toggle_high = (counter == HIGH_CYCLES - 1);
wire toggle_low = (counter == NUM_DIV - 1);

// Dual-edge counter with reset
always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
    end else begin
        if (counter_full) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
end

// Output generation with precise duty cycle control
always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 0;
    end else begin
        if (toggle_high) begin
            clk_div <= 1;
        end else if (toggle_low) begin
            clk_div <= 0;
        end
    end
end

endmodule