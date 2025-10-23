module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // 0: IDLE, 1: START, 2: DATA, 3: STOP, 4: DONE
reg [7:0] data;
reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 1; // START
                    count <= 0;
                end
            end
            1: begin // START
                state <= 2; // DATA
            end
            2: begin // DATA
                data[count] <= in;
                count <= count + 1;
                if (count == 8) begin
                    state <= 3; // STOP
                end
            end
            3: begin // STOP
                if (in) begin // stop bit detected
                    done <= 1;
                    state <= 0; // IDLE
                end else begin // stop bit not detected, wait for stop bit
                    state <= 0; // IDLE
                end
            end
            default: state <= 0; // IDLE
        endcase
        if (state != 3) begin // not in STOP state
            done <= 0;
        end
    end
end

endmodule