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
reg [3:0] delay; // duration of the timer delay
reg [3:0] remaining; // remaining time
reg [9:0] counter; // counter for clock cycles
reg [3:0] pattern; // input pattern 1101
reg shift_count; // counter for shifting in delay bits

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        pattern <= 0;
        shift_count <= 0;
        delay <= 0;
        remaining <= 0;
        counter <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (pattern == 4'b1101) begin
                    state <= 1; // SHIFT
                    pattern <= 0;
                    shift_count <= 0;
                end else if (data) begin
                    pattern <= {pattern[2:0], 1'b1};
                end else begin
                    pattern <= {pattern[2:0], 1'b0};
                end
            end
            1: begin // SHIFT
                if (shift_count == 4) begin
                    state <= 2; // COUNT
                    remaining <= delay + 1;
                    counter <= 0;
                end else begin
                    delay[3] <= data;
                    delay[2:0] <= delay[3:1];
                    shift_count <= shift_count + 1;
                end
            end
            2: begin // COUNT
                counting <= 1;
                if (counter == 999) begin
                    counter <= 0;
                    if (remaining > 1) begin
                        remaining <= remaining - 1;
                    end else begin
                        state <= 3; // DONE
                        counting <= 0;
                    end
                end else begin
                    counter <= counter + 1;
                end
                count <= remaining - 1;
            end
            3: begin // DONE
                done <= 1;
                if (ack) begin
                    state <= 0; // IDLE
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule