module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // 0: IDLE, 1: START, 2: DATA, 3: STOP
reg [2:0] data_count;
reg [7:0] data;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done <= 0;
        data_count <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 1;
                    data_count <= 0;
                    data <= 8'b0;
                end
            end
            1: begin // START
                state <= 2;
            end
            2: begin // DATA
                data[7 - data_count] <= in;
                data_count <= data_count + 1;
                if (data_count == 7) begin
                    state <= 3;
                end
            end
            3: begin // STOP
                if (in) begin // stop bit correct
                    done <= 1;
                    state <= 0;
                end else begin // stop bit incorrect
                    state <= 3; // wait for stop bit
                end
            end
        endcase
        if (state != 3 || in) begin // clear done signal
            done <= 0;
        end
    end
end

endmodule