module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

// Counter to keep track of the number of serial input data bits received
reg [3:0] cnt;

// Sequential logic to update the counter and output register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and output when the reset signal is low
        cnt <= 4'b0000;
        dout_parallel <= 8'b00000000;
    end else if (din_valid) begin
        // If the counter is less than 8, shift in the new data and increment the counter
        if (cnt < 4'b1000) begin
            // Shift in the new data using a more efficient shifting mechanism
            dout_parallel <= {dout_parallel[6:0], din_serial};
            // Increment the counter
            cnt <= cnt + 1'b1;
        end else begin
            // If the counter is 8, reset the counter
            cnt <= 4'b0000;
        end
    end
end

// Combinational logic to set the output valid signal
assign dout_valid = (cnt == 4'b1000) ? 1'b1 : 1'b0;

endmodule