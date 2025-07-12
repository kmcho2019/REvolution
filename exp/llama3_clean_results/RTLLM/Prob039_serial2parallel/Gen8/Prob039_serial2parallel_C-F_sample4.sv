module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt;
reg [1:0] state; // Simplified state machine

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00; // IDLE state
        cnt <= 4'b0000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (din_valid) begin
                    state <= 2'b01; // RECEIVING
                    cnt <= 1'b1;
                    dout_parallel <= {7'b0, din_serial};
                end
            end
            2'b01: begin // RECEIVING
                if (din_valid && cnt < 4'b1000) begin
                    cnt <= cnt + 1'b1;
                    dout_parallel <= {dout_parallel[6:0], din_serial};
                end else if (cnt == 4'b1000) begin
                    state <= 2'b10; // OUTPUT_VALID
                    dout_valid <= 1'b1;
                end else begin
                    state <= 2'b00; // Back to IDLE if din_valid is 0
                end
            end
            2'b10: begin // OUTPUT_VALID
                state <= 2'b00; // Go back to IDLE
                dout_valid <= 1'b0;
            end
        endcase
    end
end

endmodule