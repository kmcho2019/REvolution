module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

reg [7:0] dout_parallel_reg;
reg [2:0] cnt; // 3-bit binary counter
reg [7:0] shift_reg; // 8-bit shift register
reg dout_valid_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'd0;
        shift_reg <= 8'd0;
        dout_valid_reg <= 1'd0;
        dout_parallel_reg <= 8'd0;
    end else begin
        if (din_valid) begin
            // shift register implementation
            shift_reg <= {din_serial, shift_reg[7:1]};
            cnt <= cnt + 1'd1;
        end
        // update output when 8 bits have been received
        if (cnt == 3'd7) begin
            dout_parallel_reg <= shift_reg;
            dout_valid_reg <= 1'd1;
            cnt <= 3'd0;
        end
        // reset dout_valid when new data is being received
        if (din_valid && cnt == 3'd0) begin
            dout_valid_reg <= 1'd0;
        end
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule