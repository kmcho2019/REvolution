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
        // Reset the counter, output, and validity signal
        cnt <= 3'b000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        // Shift in the new data and increment the counter
        dout_parallel <= {dout_parallel[6:0], din_serial};
        cnt <= cnt + 1'b1;
        
        // If 8 bits have been received, set the output valid signal to 1 and reset the counter
        if (cnt == 3'b111) begin
            dout_valid <= 1'b1;
            cnt <= 3'b000;
        end
    end else begin
        // If the input is not valid, reset the output valid signal
        if (dout_valid) begin
            dout_valid <= 1'b0;
        end
    end
end

endmodule