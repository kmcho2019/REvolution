module freq_diveven (
    input  clk,    // Input clock signal
    input  rst_n,  // Active-low reset signal
    output reg clk_div  // Divided clock output signal
);

// Define the division factor as a parameter
parameter NUM_DIV = 8; // Must be an even number

// Validate that NUM_DIV is an even number
`ifdef VERILATOR
initial begin
    if (NUM_DIV % 2 != 0) $fatal("NUM_DIV must be an even number");
end
`endif

// Define the counter width based on the division factor
localparam CNT_WIDTH = $clog2(NUM_DIV / 2);

// Counter register
reg [CNT_WIDTH-1:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and divided clock output on reset
        cnt <= 0;
        clk_div <= 0;
    end else begin
        // Increment the counter
        if (cnt < (NUM_DIV / 2) - 1) begin
            cnt <= cnt + 1;
        end else begin
            // Toggle the divided clock output and reset the counter
            clk_div <= ~clk_div;
            cnt <= 0;
        end
    end
end

endmodule