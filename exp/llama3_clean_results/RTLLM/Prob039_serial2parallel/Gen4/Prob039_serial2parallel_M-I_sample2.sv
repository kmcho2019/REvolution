module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

parameter COUNTER_WIDTH = 4;

reg [COUNTER_WIDTH-1:0] cnt;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= {COUNTER_WIDTH{1'b0}};
        dout_parallel <= {8{1'b0}};
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        if (cnt < (1 << (COUNTER_WIDTH-1))) begin
            // Shift the bits, with din_serial becoming the MSB
            dout_parallel <= {din_serial, dout_parallel[7:1]};
            cnt <= cnt + 1;
            dout_valid <= 1'b0; // Reset valid during data reception
        end else begin
            cnt <= {COUNTER_WIDTH{1'b0}}; // Reset counter
            dout_valid <= 1'b1; // Set valid after receiving 8 bits
        end
    end else begin
        // If no valid input, do nothing but keep the previous state
    end
end

endmodule