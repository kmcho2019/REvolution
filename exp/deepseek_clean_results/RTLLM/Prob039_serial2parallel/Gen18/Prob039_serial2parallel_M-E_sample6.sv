module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [7:0] buffer;
    reg [2:0] write_ptr;
    reg wrap_flag;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer <= 8'b0;
            write_ptr <= 3'b0;
            wrap_flag <= 1'b0;
            dout_valid <= 1'b0;
            dout_parallel <= 8'b0;
        end
        else begin
            dout_valid <= 1'b0;
            
            if (din_valid) begin
                // Store input at current pointer position
                buffer[write_ptr] <= din_serial;
                
                // Update pointer and detect wrap-around
                if (write_ptr == 3'd7) begin
                    write_ptr <= 3'b0;
                    wrap_flag <= 1'b1;
                end
                else begin
                    write_ptr <= write_ptr + 1'b1;
                    wrap_flag <= 1'b0;
                end
                
                // Output when pointer wraps around
                if (wrap_flag) begin
                    dout_parallel <= buffer;
                    dout_valid <= 1'b1;
                end
            end
        end
    end

endmodule