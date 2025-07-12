module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    reg [2:0] bit_count;
    
    // dout_valid is high when counter is at max value
    assign dout_valid = (bit_count == 3'd7) & din_valid;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
            bit_count <= 3'b0;
        end
        else if (din_valid) begin
            // Shift new bit into LSB while maintaining previous bits
            dout_parallel <= {dout_parallel[6:0], din_serial};
            
            // Increment counter (automatically wraps at 7)
            bit_count <= bit_count + 1'b1;
        end
    end

endmodule