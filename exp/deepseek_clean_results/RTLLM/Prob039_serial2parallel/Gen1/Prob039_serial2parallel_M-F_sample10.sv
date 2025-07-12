module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] cnt;  // 3-bit counter (0-7)
    reg [7:0] data_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'b0;
            data_reg <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;  // Default to 0 unless we complete a byte
            
            if (din_valid) begin
                // Power-efficient bit assignment (MSB first)
                data_reg[7-cnt] <= din_serial;
                
                if (cnt == 3'd7) begin
                    // Output complete byte
                    dout_parallel <= data_reg;
                    dout_valid <= 1'b1;
                    cnt <= 3'b0;
                end
                else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

endmodule