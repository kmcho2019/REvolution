module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE
reg [3:0] delay; // delay value
reg [9:0] counter; // counter for remaining time
reg [3:0] count_out; // output count value

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        count_out <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data == 1) begin
                    state <= 4; // shift 1101
                    count_out <= 0;
                end else begin
                    state <= 0;
                end
            end
            4: begin // shift 1101
                if (data == 1) begin
                    state <= 5; // shift 110
                    count_out <= 0;
                end else begin
                    state <= 0; // reset to IDLE
                end
            end
            5: begin // shift 110
                if (data == 0) begin
                    state <= 6; // shift 11
                    count_out <= 0;
                end else begin
                    state <= 0; // reset to IDLE
                end
            end
            6: begin // shift 11
                if (data == 1) begin
                    state <= 1; // SHIFT
                    count_out <= 0;
                end else begin
                    state <= 0; // reset to IDLE
                end
            end
            1: begin // SHIFT
                delay[3] <= data;
                state <= 7; // shift delay[2]
                count_out <= 0;
            end
            7: begin // shift delay[2]
                delay[2] <= data;
                state <= 8; // shift delay[1]
                count_out <= 0;
            end
            8: begin // shift delay[1]
                delay[1] <= data;
                state <= 9; // shift delay[0]
                count_out <= 0;
            end
            9: begin // shift delay[0]
                delay[0] <= data;
                state <= 2; // COUNT
                counter <= (delay + 1) * 1000 - 1;
                count_out <= delay;
                counting <= 1;
            end
            2: begin // COUNT
                if (counter == 0) begin
                    state <= 3; // DONE
                    counting <= 0;
                    done <= 1;
                end else if (counter % 1000 == 0) begin
                    count_out <= count_out - 1;
                end
                counter <= counter - 1;
            end
            3: begin // DONE
                if (ack == 1) begin
                    state <= 0; // IDLE
                    count_out <= 0;
                    counting <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

assign count = count_out;

endmodule