module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

reg [2:0] state;
reg [3:0] seq_det;
reg [3:0] shift_reg;
reg [1:0] shift_cnt;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        seq_det <= 0;
        shift_reg <= 0;
        shift_cnt <= 0;
    end else begin
        case (state)
            0: begin // Sequence Detection
                seq_det <= {seq_det[2:0], data};
                if (seq_det == 4'b1101) begin
                    state <= 1;
                    shift_cnt <= 0;
                end
            end
            1: begin // Shifting
                shift_ena <= 1;
                shift_reg <= {shift_reg[2:0], data};
                shift_cnt <= shift_cnt + 1;
                if (shift_cnt == 4) begin
                    state <= 2;
                end
            end
            2: begin // Counting/Timer Expiration
                counting <= 1;
                if (done_counting) begin
                    state <= 3;
                end
            end
            3: begin // Done
                done <= 1;
                if (ack) begin
                    state <= 0;
                end
            end
        endcase
    end
end

assign shift_ena = (state == 1) ? 1'b1 : 1'b0;
assign counting = (state == 2) ? 1'b1 : 1'b0;
assign done = (state == 3) ? 1'b1 : 1'b0;

endmodule