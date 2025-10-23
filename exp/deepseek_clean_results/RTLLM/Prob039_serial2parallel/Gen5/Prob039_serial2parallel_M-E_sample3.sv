module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] write_ptr;  // 3-bit pointer (0-7)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
            write_ptr <= 3'b0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;  // Default to invalid
            
            if (din_valid) begin
                // Store input bit at current pointer position
                dout_parallel[write_ptr] <= din_serial;
                
                // Increment pointer
                if (write_ptr == 3'd7) begin
                    write_ptr <= 3'd0;
                    dout_valid <= 1'b1;  // Valid when pointer wraps
                end
                else begin
                    write_ptr <= write_ptr + 1'b1;
                end
            end
        end
    end

endmodule