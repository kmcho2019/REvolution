module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [1:0] seq_state;
reg [1:0] timer_state;
reg start;
reg [2:0] shift_cnt;

always @(posedge clk) begin
    if (reset) begin
        seq_state <= 2'b00;
        timer_state <= 2'b00;
        start <= 1'b0;
        shift_cnt <= 3'b000;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        // Sequence detector
        case (seq_state)
            2'b00: begin
                if (data) begin
                    seq_state <= 2'b01;
                end
            end
            2'b01: begin
                if (~data) begin
                    seq_state <= 2'b10;
                end else begin
                    seq_state <= 2'b00;
                end
            end
            2'b10: begin
                if (data) begin
                    seq_state <= 2'b11;
                end else begin
                    seq_state <= 2'b00;
                end
            end
            2'b11: begin
                if (~data) begin
                    start <= 1'b1;
                    seq_state <= 2'b00;
                end else begin
                    seq_state <= 2'b00;
                end
            end
        endcase

        // Timer controller
        case (timer_state)
            2'b00: begin // IDLE
                if (start) begin
                    timer_state <= 2'b01;
                    shift_cnt <= 3'b000;
                    start <= 1'b0;
                end
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
            2'b01: begin // SHIFTING
                shift_ena <= 1'b1;
                shift_cnt <= shift_cnt + 1'b1;
                if (shift_cnt == 3'b100) begin
                    timer_state <= 2'b10;
                end
                counting <= 1'b0;
                done <= 1'b0;
            end
            2'b10: begin // COUNTING
                shift_ena <= 1'b0;
                counting <= 1'b1;
                if (done_counting) begin
                    timer_state <= 2'b11;
                end
                done <= 1'b0;
            end
            2'b11: begin // DONE
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b1;
                if (ack) begin
                    timer_state <= 2'b00;
                end
            end
        endcase
    end
end

endmodule