module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt; // 4-bit counter to track received serial data bits

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset condition
        cnt <= 4'd0; // clear counter
        dout_parallel <= 8'd0; // clear output parallel data
        dout_valid <= 1'd0; // clear output valid signal
    end else if (din_valid) begin // valid input data condition
        if (cnt < 4'd8) begin // check if 8 bits have been received
            dout_parallel <= {din_serial, dout_parallel[7:1]}; // shift in serial data from MSB to LSB
            cnt <= cnt + 1; // increment counter
            dout_valid <= 1'd0; // output valid signal remains low
        end else begin // 8 bits have been received
            dout_valid <= 1'd1; // set output valid signal high
        end
    end else begin // invalid input data condition
        cnt <= 4'd0; // reset counter
        dout_valid <= 1'd0; // clear output valid signal
    end
end

endmodule