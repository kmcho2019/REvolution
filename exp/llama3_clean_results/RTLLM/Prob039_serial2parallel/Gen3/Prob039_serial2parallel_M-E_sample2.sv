module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [1:0] state;
reg [2:0] cnt;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00; // idle state
        cnt <= 3'b000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // idle state
                if (din_valid) begin
                    state <= 2'b01; // conversion state
                    cnt <= 3'b001;
                    dout_parallel <= {7'b0, din_serial};
                end
            end
            2'b01: begin // conversion state
                if (cnt < 3'b100) begin
                    cnt <= cnt + 1;
                    dout_parallel <= {dout_parallel[6:0], din_serial};
                end else begin
                    state <= 2'b10; // output state
                end
            end
            2'b10: begin // output state
                dout_valid <= 1'b1;
                state <= 2'b00; // idle state
            end
            default: begin
                state <= 2'b00; // idle state
            end
        endcase
    end
end

always @ (posedge clk) begin
    if (state == 2'b00 && ~din_valid) begin
        dout_valid <= 1'b0;
    end
end

endmodule