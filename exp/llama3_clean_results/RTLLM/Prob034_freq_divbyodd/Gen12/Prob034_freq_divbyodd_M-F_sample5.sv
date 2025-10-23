module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

// Define the counter for tracking clock cycles
logic [$clog2(NUM_DIV-1):0] cnt;

// Define the clock divider output
logic clk_div_int;

// Initialize the counter and clock divider on reset
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div_int <= 1'b0;
    end else begin
        // Increment the counter on each clock cycle
        if (cnt == NUM_DIV - 1) begin
            cnt <= 0;
            clk_div_int <= ~clk_div_int;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

// Assign the divided clock output to the output port
assign clk_div = clk_div_int;

endmodule