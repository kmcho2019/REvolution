module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [2:0] cnt; // 3-bit counter to keep track of the number of serial input data bits received

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and output when the reset signal is low
        cnt <= 3'b000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        // Shift in the new data
        dout_parallel <= {dout_parallel[6:0], din_serial};
        // Increment the counter
        cnt <= cnt + 1'b1;
        // Set the output valid signal to 1 when the counter reaches 8
        if (cnt == 3'b111) begin
            cnt <= 3'b000;
            dout_valid <= 1'b1;
        end else begin
            dout_valid <= 1'b0;
        end
    end else begin
        // If the input is not valid, do not update the counter or output
        cnt <= cnt;
        dout_parallel <= dout_parallel;
        dout_valid <= 1'b0;
    end
end

endmodule