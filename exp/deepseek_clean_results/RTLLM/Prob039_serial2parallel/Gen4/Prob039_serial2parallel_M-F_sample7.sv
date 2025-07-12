module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] write_ptr;  // 3-bit write pointer (0-7)
    reg [7:0] buffer;     // Circular buffer storage
    wire wrap_flag = (write_ptr == 3'd7);  // Pre-computed wrap condition

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            write_ptr <= 3'b0;
            buffer <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            // Default assignments
            dout_valid <= 1'b0;

            // Buffer update (clock-gated by din_valid)
            if (din_valid) begin
                buffer[write_ptr] <= din_serial;
                
                // Pointer update
                write_ptr <= wrap_flag ? 3'b0 : (write_ptr + 1'b1);
                
                // Output generation (one cycle after last write)
                if (wrap_flag) begin
                    dout_parallel <= {buffer[6:0], din_serial};
                    dout_valid <= 1'b1;
                end
            end
        end
    end

endmodule