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

reg [2:0] state;
reg [3:0] seq_det;
reg [1:0] shift_cnt;

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
                    shift_ena <= 1;
                end else begin
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 0;
                end
            end
            1: begin // Shifting
                shift_cnt <= shift_cnt + 1;
                if (shift_cnt == 4) begin
                    state <= 2;
                    shift_ena <= 0;
                    counting <= 1;
                end
            end
            2: begin // Counting
                if (done_counting) begin
                    state <= 3;
                    counting <= 0;
                    done <= 1;
                end
            end
            3: begin // Done
                if (ack) begin
                    state <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule