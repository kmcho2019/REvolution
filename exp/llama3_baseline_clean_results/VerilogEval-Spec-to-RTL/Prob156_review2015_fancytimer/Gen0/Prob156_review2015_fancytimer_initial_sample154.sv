module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] state; // 0: IDLE, 1: SHIFTING, 2: COUNTING, 3: DONE
reg [3:0] delay; // delay value
reg [11:0] counter; // counter for counting down
reg [3:0] sequence; // sequence for detecting start sequence
reg [3:0] shift_count; // counter for shifting in delay bits

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        delay <= 0;
        counter <= 0;
        sequence <= 0;
        shift_count <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (sequence == 4'b1101) begin
                    state <= 1; // SHIFTING
                    sequence <= 0;
                    shift_count <= 0;
                end else begin
                    sequence <= {sequence[2:0], data};
                end
            end
            1: begin // SHIFTING
                delay <= {delay[2:0], data};
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    state <= 2; // COUNTING
                    counter <= (delay + 1) * 1000 - 1;
                    counting <= 1;
                end
            end
            2: begin // COUNTING
                if (counter == 0) begin
                    state <= 3; // DONE
                    counting <= 0;
                    done <= 1;
                end else begin
                    counter <= counter - 1;
                    if (counter % 1000 == 0) begin
                        count <= delay - (counter / 1000);
                    end
                end
            end
            3: begin // DONE
                if (ack) begin
                    state <= 0; // IDLE
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule