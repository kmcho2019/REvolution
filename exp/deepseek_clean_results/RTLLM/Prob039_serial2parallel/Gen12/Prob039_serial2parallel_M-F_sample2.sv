module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] counter;  // Counts 0-7 (3 bits sufficient)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
            counter <= 3'b0;
        end
        else begin
            dout_valid <= 1'b0;  // Default to invalid
            
            if (din_valid) begin
                if (counter < 3'd7) begin
                    // Shift in new bit (MSB first)
                    dout_parallel <= {dout_parallel[6:0], din_serial};
                    counter <= counter + 1'b1;
                end
                else begin  // counter == 7
                    // Capture final bit and output
                    dout_parallel <= {dout_parallel[6:0], din_serial};
                    dout_valid <= 1'b1;
                    counter <= 3'b0;
                end
            end
        end
    end

endmodule