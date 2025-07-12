module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

reg [2:0] state; // IDLE, START, DATA, STOP, ERROR
reg [3:0] data_cnt; // Counter for data bits
reg [7:0] data; // Collected data bits

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        data_cnt <= 0;
        data <= 0;
        done <= 0;
    end
    else begin
        case (state)
            0: begin // IDLE
                if (!in) begin
                    state <= 1; // START
                    data_cnt <= 0;
                end
            end
            1: begin // START
                data_cnt <= 0;
                data[0] <= in;
                state <= 2; // DATA
            end
            2: begin // DATA
                if (data_cnt == 7) begin
                    data[7] <= in;
                    if (in) begin
                        state <= 3; // STOP
                    end
                    else begin
                        state <= 4; // ERROR
                    end
                end
                else begin
                    data[data_cnt + 1] <= in;
                    data_cnt <= data_cnt + 1;
                end
            end
            3: begin // STOP
                if (in) begin
                    state <= 0; // IDLE
                    done <= 1;
                end
                else begin
                    state <= 4; // ERROR
                end
            end
            4: begin // ERROR
                if (in) begin
                    state <= 0; // IDLE
                end
            end
            default: state <= 0; // IDLE
        endcase
    end
end

always @(negedge clk) begin
    done <= 0;
end

endmodule