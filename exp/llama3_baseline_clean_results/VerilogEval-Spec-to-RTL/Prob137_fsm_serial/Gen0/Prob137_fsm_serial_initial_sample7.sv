module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // 0: IDLE, 1: START, 2: DATA, 3: STOP
reg [7:0] data; // received data
reg [2:0] data_cnt; // data bit counter

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE
        data <= 8'b0;
        data_cnt <= 3'b0;
        done <= 1'b0;
    end else begin
        case (state)
            0: begin // IDLE
                if (~in) begin
                    state <= 1; // START
                end
            end
            1: begin // START
                state <= 2; // DATA
                data_cnt <= 3'b1;
                data[0] <= in;
            end
            2: begin // DATA
                if (data_cnt == 8) begin
                    state <= 3; // STOP
                end else begin
                    data_cnt <= data_cnt + 1'b1;
                    data[data_cnt] <= in;
                end
            end
            3: begin // STOP
                if (in) begin
                    done <= 1'b1; // indicate byte received
                    state <= 0; // IDLE
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state == 0) begin
        done <= 1'b0; // reset 'done' signal in IDLE state
    end
end

endmodule