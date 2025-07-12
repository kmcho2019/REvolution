module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] bit_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt <= 3'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;
            
            if (din_valid) begin
                dout_parallel <= {dout_parallel[6:0], din_serial};
                
                if (bit_cnt == 3'd7) begin
                    dout_valid <= 1'b1;
                end
                
                bit_cnt <= bit_cnt + 1'b1;
            end
        end
    end

endmodule