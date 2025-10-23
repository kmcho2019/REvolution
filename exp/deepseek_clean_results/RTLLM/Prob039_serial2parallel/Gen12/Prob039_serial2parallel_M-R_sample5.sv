module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    reg [2:0] counter;  // 3-bit counter for 0-7

    // Valid when counter is 7 and din_valid is active
    assign dout_valid = (counter == 3'd7) & din_valid;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
            counter <= 3'b0;
        end
        else if (din_valid) begin
            if (counter == 3'd7) begin
                // Shift in final bit and reset counter
                dout_parallel <= {dout_parallel[6:0], din_serial};
                counter <= 3'b0;
            end
            else begin
                // Shift in new bit (MSB first)
                dout_parallel <= {dout_parallel[6:0], din_serial};
                counter <= counter + 1'b1;
            end
        end
    end

endmodule