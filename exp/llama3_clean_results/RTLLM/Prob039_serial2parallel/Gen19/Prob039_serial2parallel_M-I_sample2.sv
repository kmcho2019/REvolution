module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt; // 4-bit counter to keep track of the number of serial input data bits received

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and output when the reset signal is low
        cnt <= 4'b0000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        // If the counter is less than 8, set the corresponding bit in dout_parallel and increment the counter
        if (cnt < 4'b1000) begin
            // Directly set the corresponding bit in dout_parallel
            dout_parallel <= dout_parallel | (din_serial << cnt);
            // Increment the counter
            cnt <= cnt + 1'b1;
        end else begin
            // If the counter is 8, reset the counter and set the output valid signal to 1
            cnt <= 4'b0000;
            dout_valid <= 1'b1;
        end
    end else begin
        // If the input is not valid, do not update the counter or output
        cnt <= cnt;
        // Set the output valid signal to 0 only when necessary
        if (dout_valid)
            dout_valid <= 1'b0;
    end
end

endmodule