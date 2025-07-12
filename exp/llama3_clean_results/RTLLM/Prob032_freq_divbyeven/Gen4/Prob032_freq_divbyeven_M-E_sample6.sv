module freq_diveven (
    input  clk,    // Input clock signal
    input  rst_n,  // Active-low reset signal
    output reg clk_div  // Divided clock output signal
);

parameter NUM_DIV = 8; // Must be an even number

reg [3:0] cnt_half; // Counter for the first stage
reg toggle_stage; // Single-bit register for the second stage
reg rst_n_sync; // Synchronized reset signal

always @(posedge clk) begin
    rst_n_sync <= rst_n; // Synchronize rst_n with the clock domain
end

always @(posedge clk or negedge rst_n_sync) begin
    if (!rst_n_sync) begin
        cnt_half <= 0;
        toggle_stage <= 0;
        clk_div <= 0;
    end else if (cnt_half == (NUM_DIV / 2 - 1)) begin
        cnt_half <= 0;
        toggle_stage <= !toggle_stage;
        clk_div <= toggle_stage;
    end else begin
        cnt_half <= cnt_half + 1;
    end
end

endmodule