module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt; // 4-bit counter to keep track of the number of serial input data bits received

always @(posedge clk) begin
    if (~rst_n) begin
        // Reset the module
        cnt <= 4'b0000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        case (cnt)
            4'b0000: begin
                // Receive first bit
                dout_parallel <= {din_serial, 7'b0000000};
                cnt <= cnt + 1'b1;
                dout_valid <= 1'b0;
            end
            4'b0001: begin
                // Receive second bit
                dout_parallel <= {dout_parallel[7:1], din_serial};
                cnt <= cnt + 1'b1;
                dout_valid <= 1'b0;
            end
            4'b0010: begin
                // Receive third bit
                dout_parallel <= {dout_parallel[7:1], din_serial};
                cnt <= cnt + 1'b1;
                dout_valid <= 1'b0;
            end
            4'b0011: begin
                // Receive fourth bit
                dout_parallel <= {dout_parallel[7:1], din_serial};
                cnt <= cnt + 1'b1;
                dout_valid <= 1'b0;
            end
            4'b0100: begin
                // Receive fifth bit
                dout_parallel <= {dout_parallel[7:1], din_serial};
                cnt <= cnt + 1'b1;
                dout_valid <= 1'b0;
            end
            4'b0101: begin
                // Receive sixth bit
                dout_parallel <= {dout_parallel[7:1], din_serial};
                cnt <= cnt + 1'b1;
                dout_valid <= 1'b0;
            end
            4'b0110: begin
                // Receive seventh bit
                dout_parallel <= {dout_parallel[7:1], din_serial};
                cnt <= cnt + 1'b1;
                dout_valid <= 1'b0;
            end
            4'b0111: begin
                // Receive eighth bit
                dout_parallel <= {dout_parallel[7:1], din_serial};
                cnt <= 4'b0000; // Reset counter
                dout_valid <= 1'b1; // Set valid signal
            end
            default: begin
                // Handle any other state (should not occur)
                cnt <= cnt;
                dout_parallel <= dout_parallel;
                dout_valid <= 1'b0;
            end
        endcase
    end else begin
        // If input is not valid, do not update counter or output
        cnt <= cnt;
        dout_parallel <= dout_parallel;
        dout_valid <= 1'b0;
    end
end

endmodule