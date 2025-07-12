module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [23:0] byte_window;  // Stores last 3 bytes (newest at LSB)
    wire is_message_start = byte_window[19];  // in[3] of 3rd most recent byte

    always @(posedge clk) begin
        if (reset) begin
            byte_window <= 24'b0;
            done <= 1'b0;
        end else begin
            // Shift in new byte
            byte_window <= {byte_window[15:0], in};
            
            // Check for complete message every cycle
            done <= (byte_window[2:0] == 3'b111) ? 1'b0 :  // Prevent done on first byte
                   (byte_window[19] & (byte_window[2:0] != 3'b000));
        end
    end

endmodule