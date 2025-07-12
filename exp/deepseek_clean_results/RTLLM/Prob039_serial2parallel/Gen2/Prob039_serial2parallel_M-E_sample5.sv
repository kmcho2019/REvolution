module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] wr_ptr;  // 3-bit write pointer (0-7)
    reg [7:0] data_buf;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 3'b0;
            data_buf <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;
            
            if (din_valid) begin
                // Store data at current pointer position
                data_buf[7-wr_ptr] <= din_serial;
                
                // Update pointer
                if (wr_ptr == 3'd7) begin
                    wr_ptr <= 3'b0;
                    dout_parallel <= data_buf;
                    dout_valid <= 1'b1;
                end
                else begin
                    wr_ptr <= wr_ptr + 1'b1;
                end
            end
        end
    end

endmodule