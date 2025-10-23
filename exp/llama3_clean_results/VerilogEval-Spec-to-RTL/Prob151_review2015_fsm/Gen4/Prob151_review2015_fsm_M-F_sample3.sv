module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [2:0] state; // 0: Sequence Detection, 1: Shifting, 2: Counting, 3: Done
reg [3:0] seq_det; // Sequence detection register
reg [1:0] shift_cnt; // Shift counter

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        seq_det <= 0;
        shift_cnt <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // Sequence Detection
                seq_det <= {seq_det[2:0], data};
                if (seq_det == 4'b1101) begin
                    state <= 1;
                    shift_cnt <= 0;
                end
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
            1: begin // Shifting
                shift_cnt <= shift_cnt + 1;
                shift_ena <= (shift_cnt < 4) ? 1 : 0;
                counting <= 0;
                done <= 0;
                if (shift_cnt == 4) begin
                    state <= 2;
                end
            end
            2: begin // Counting
                shift_ena <= 0;
                counting <= 1;
                done <= 0;
                if (done_counting) begin
                    state <= 3;
                end
            end
            3: begin // Done
                shift_ena <= 0;
                counting <= 0;
                done <= 1;
                if (ack) begin
                    state <= 0;
                end
            end
        endcase
    end
end

endmodule