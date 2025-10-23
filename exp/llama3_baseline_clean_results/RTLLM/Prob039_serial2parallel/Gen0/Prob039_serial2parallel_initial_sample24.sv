module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt; // 4-bit counter
reg [7:0] data; // 8-bit data register

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'd0; // Reset counter
        data <= 8'd0; // Reset data register
        dout_valid <= 1'd0; // Reset valid signal
        dout_parallel <= 8'd0; // Reset parallel output
    end else begin
        if (din_valid) begin
            data <= {din_serial, data[7:1]}; // Shift data to the right and fill MSB with din_serial
            cnt <= cnt + 1; // Increment counter
        end
        
        if (cnt == 4'd8) begin
            dout_valid <= 1'd1; // Set valid signal to 1 when 8 bits are received
            dout_parallel <= data; // Output the parallel data
            cnt <= 4'd0; // Reset counter for next set of data
            data <= 8'd0; // Reset data register
            dout_valid <= 1'd0; // Reset valid signal
        end
    end
end

endmodule