module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    reg [7:0] data_buffer;
    reg [3:0] wr_ptr;  // Need 4 bits to detect wrap-around (0-7 then back to 0)

    // Combinational valid signal
    assign dout_valid = din_valid & (wr_ptr == 4'd8);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_buffer <= 8'b0;
            wr_ptr <= 4'b0;
            dout_parallel <= 8'b0;
        end
        else begin
            if (din_valid) begin
                // Store incoming bit at current pointer position
                data_buffer[wr_ptr[2:0]] <= din_serial;
                
                // Update write pointer (wrap after 7)
                if (wr_ptr == 4'd7)
                    wr_ptr <= 4'b0;
                else
                    wr_ptr <= wr_ptr + 1;

                // Register output when pointer wraps
                if (wr_ptr == 4'd7)
                    dout_parallel <= {din_serial, data_buffer[7:1]};
            end
        end
    end

endmodule