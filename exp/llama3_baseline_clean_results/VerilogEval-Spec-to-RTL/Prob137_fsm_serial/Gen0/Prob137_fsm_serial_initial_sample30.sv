module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // 3 states: IDLE (0), START (1), DATA (2), STOP (3), WAIT_STOP (4)
reg [7:0] data;
reg [3:0] data_cnt;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE
        data <= 8'd0;
        data_cnt <= 4'd0;
        done <= 1'b0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 1; // START
                end
            end
            1: begin // START
                state <= 2; // DATA
                data_cnt <= 4'd1;
                data[0] <= in;
            end
            2: begin // DATA
                if (data_cnt < 4'd8) begin
                    data_cnt <= data_cnt + 4'd1;
                    data[data_cnt] <= in;
                end else begin
                    state <= 3; // STOP
                end
            end
            3: begin // STOP
                if (in) begin // stop bit detected
                    state <= 0; // IDLE
                    done <= 1'b1;
                end else begin
                    state <= 4; // WAIT_STOP
                end
            end
            4: begin // WAIT_STOP
                if (in) begin // stop bit detected
                    state <= 0; // IDLE
                end
            end
            default: state <= 0; // IDLE
        endcase
    end
end

always @(negedge clk) begin
    done <= 1'b0;
end

endmodule