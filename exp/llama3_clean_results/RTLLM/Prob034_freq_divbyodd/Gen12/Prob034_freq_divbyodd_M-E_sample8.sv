module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

// Define the counter for tracking clock cycles
logic [$clog2(NUM_DIV):0] cnt;

// Initialize the counter and divided clock output on reset
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div <= 1'b0;
    end else begin
        // Increment the counter on each clock cycle
        if (cnt == NUM_DIV - 1) begin
            cnt <= 0;
            clk_div <= ~clk_div;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule