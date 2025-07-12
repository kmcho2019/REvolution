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

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: COUNTING, 3: DONE, 4: ACK
reg [3:0] shift_cnt; // counter for shift_ena
reg [3:0] pattern; // flag to detect pattern 1101

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        shift_cnt <= 0;
        pattern <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data == 1 && pattern == 8'b110) begin
                    pattern <= 8'b1101;
                    if (pattern == 8'b1101) begin
                        state <= 1;
                    end
                end else if (data == 0 && pattern == 8'b110) begin
                    pattern <= 8'b1100;
                end else if (data == 1 && pattern == 8'b11) begin
                    pattern <= 8'b110;
                end else if (data == 0 && pattern == 8'b11) begin
                    pattern <= 8'b10;
                end else if (data == 1 && pattern == 8'b1) begin
                    pattern <= 8'b11;
                end else if (data == 0 && pattern == 8'b1) begin
                    pattern <= 8'b0;
                end else if (data == 1 && pattern == 8'b0) begin
                    pattern <= 8'b1;
                end else begin
                    pattern <= 8'b0;
                end
            end
            1: begin // SHIFT
                shift_ena <= 1;
                if (shift_cnt == 4) begin
                    state <= 2;
                    shift_cnt <= 0;
                    shift_ena <= 0;
                end else begin
                    shift_cnt <= shift_cnt + 1;
                end
            end
            2: begin // COUNTING
                counting <= 1;
                if (done_counting) begin
                    state <= 3;
                    counting <= 0;
                end
            end
            3: begin // DONE
                done <= 1;
                if (ack) begin
                    state <= 4;
                    done <= 0;
                end
            end
            4: begin // ACK
                if (ack) begin
                    state <= 0;
                end
            end
        endcase
    end
end

assign shift_ena = (state == 1) ? 1 : 0;
assign counting = (state == 2) ? 1 : 0;
assign done = (state == 3) ? 1 : 0;

endmodule