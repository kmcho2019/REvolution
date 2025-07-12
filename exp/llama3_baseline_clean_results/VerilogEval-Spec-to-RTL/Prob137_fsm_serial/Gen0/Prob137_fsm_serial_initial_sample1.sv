module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // 0: IDLE, 1: START, 2: DATA, 3: STOP, 4: ERROR
reg [3:0] data_cnt; // counter for data bits
reg [7:0] data; // register to hold the received data byte

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done <= 0;
        data_cnt <= 0;
        data <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 1; // START
                    data_cnt <= 0;
                    data <= 0;
                end
            end
            1: begin // START
                state <= 2; // DATA
                data[0] <= in;
            end
            2: begin // DATA
                if (data_cnt == 7) begin
                    data[7] <= in;
                    state <= 3; // STOP
                end else begin
                    data[data_cnt + 1] <= in;
                    data_cnt <= data_cnt + 1;
                end
            end
            3: begin // STOP
                if (in) begin // stop bit detected
                    state <= 0; // IDLE
                    done <= 1;
                end else begin
                    state <= 4; // ERROR
                end
            end
            4: begin // ERROR
                if (in) begin // stop bit detected
                    state <= 0; // IDLE
                end
            end
        endcase
    end
end

always @(negedge clk) begin
    if (state == 0 && done) begin
        done <= 0;
    end
end

endmodule