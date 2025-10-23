module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [7:0] buffer;
    reg [2:0] wr_ptr;
    reg wrap_flag;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer <= 8'b0;
            wr_ptr <= 3'b0;
            wrap_flag <= 1'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;  // Default

            if (din_valid) begin
                // Circular write operation
                buffer[wr_ptr] <= din_serial;
                
                // Pointer update with wrap-around detection
                if (wr_ptr == 3'd7) begin
                    wr_ptr <= 3'd0;
                    wrap_flag <= 1'b1;
                end
                else begin
                    wr_ptr <= wr_ptr + 1'b1;
                end
            end

            // Output generation on wrap-around
            if (wrap_flag) begin
                dout_parallel <= buffer;
                dout_valid <= 1'b1;
                wrap_flag <= 1'b0;
            end
        end
    end

endmodule