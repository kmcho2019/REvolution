module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

reg [2:0] state; // idle, shift, count, done
reg [3:0] seq; // sequence detector

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        seq <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        case (state)
            0: begin // idle
                if (data == 1'b1) begin
                    seq[0] <= 1'b1;
                    state <= 1;
                end
                else begin
                    seq <= 0;
                end
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
            1: begin // idle (second 1)
                if (data == 1'b1) begin
                    seq[1] <= 1'b1;
                    state <= 2;
                end
                else if (data == 1'b0) begin
                    seq <= 0;
                    state <= 0;
                end
            end
            2: begin // idle (first 0)
                if (data == 1'b0) begin
                    seq[2] <= 1'b0;
                    state <= 3;
                end
                else if (data == 1'b1) begin
                    seq <= 0;
                    state <= 0;
                end
            end
            3: begin // idle (second 1)
                if (data == 1'b1) begin
                    seq[3] <= 1'b1;
                    state <= 4; // shift1
                end
                else if (data == 1'b0) begin
                    seq <= 0;
                    state <= 0;
                end
            end
            4: begin // shift1
                shift_ena <= 1;
                state <= 5;
            end
            5: begin // shift2
                shift_ena <= 1;
                state <= 6;
            end
            6: begin // shift3
                shift_ena <= 1;
                state <= 7;
            end
            7: begin // shift4
                shift_ena <= 1;
                state <= 8;
            end
            8: begin // count
                shift_ena <= 0;
                counting <= 1;
                if (done_counting) begin
                    state <= 9;
                end
            end
            9: begin // done
                counting <= 0;
                done <= 1;
                if (ack) begin
                    state <= 0;
                    done <= 0;
                end
            end
            default: state <= 0;
        endcase
    end
end

endmodule