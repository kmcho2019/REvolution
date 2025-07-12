module serial2parallel(
    input clk, 
    input rst_n, 
    input din_serial, 
    input din_valid, 
    output reg [7:0] dout_parallel, 
    output reg dout_valid
);

reg [3:0] cnt;
reg [7:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        dout_valid <= 0;
        shift_reg <= 0;
    end else if (din_valid) begin
        shift_reg <= {din_serial, shift_reg[7:1]};
        cnt <= cnt + 1;
        if (cnt == 8) begin
            dout_parallel <= shift_reg;
            dout_valid <= 1;
            cnt <= 0;
        end else begin
            dout_valid <= 0;
        end
    end else begin
        dout_valid <= 0;
    end
end

endmodule