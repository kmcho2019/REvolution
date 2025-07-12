module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt; // 4-bit counter to keep track of the number of serial input data bits received
reg [7:0] next_dout_parallel; // temporary variable to hold next value of dout_parallel

// Separate reset logic using assign
assign dout_valid = (rst_n) ? (cnt == 4'b1000) : 1'b0;

// Main logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and output
        cnt <= 4'b0000;
        dout_parallel <= 8'b00000000;
    end else if (din_valid) begin
        // If the counter is less than 8, shift in the new data and increment the counter
        if (cnt < 4'b1000) begin
            // Shift in the new data using a more efficient shifting mechanism
            next_dout_parallel = {dout_parallel[6:0], din_serial};
            // Increment the counter
            cnt <= cnt + 1'b1;
            // Update dout_parallel
            dout_parallel <= next_dout_parallel;
        end else begin
            // If the counter is 8, reset the counter
            cnt <= 4'b0000;
        end
    end
end

endmodule