module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

reg [2:0] state; // 0: IDLE, 1: START, 2: DATA, 3: STOP
reg [7:0] data_cnt; // counter for data bits
reg [7:0] data; // register to store received data
reg done_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE
        data_cnt <= 0;
        data <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin
                    state <= 1; // START
                    data_cnt <= 0;
                    data <= 0;
                end
            end
            1: begin // START
                state <= 2; // DATA
            end
            2: begin // DATA
                data[7 - data_cnt] <= in; // store data bit
                data_cnt <= data_cnt + 1;
                if (data_cnt == 8) begin
                    state <= 3; // STOP
                end
            end
            3: begin // STOP
                if (in) begin
                    done_reg <= 1; // set done signal
                    state <= 0; // IDLE
                end
            end
            default: state <= 0; // IDLE
        endcase
    end
end

assign done = done_reg;

always @(posedge clk) begin
    if (state == 3 && !in) begin
        done_reg <= 0; // reset done signal
    end
end

endmodule