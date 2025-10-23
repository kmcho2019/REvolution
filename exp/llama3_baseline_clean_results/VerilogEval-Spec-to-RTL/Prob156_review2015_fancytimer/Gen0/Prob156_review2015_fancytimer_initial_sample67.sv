module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] state; // state variable
reg [3:0] delay; // delay value
reg [3:0] remaining; // remaining time
reg [3:0] counter; // counter to keep track of 1000 cycles
reg [3:0] pattern; // pattern to recognize 1101

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE state
        pattern <= 0;
        delay <= 0;
        remaining <= 0;
        counter <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (pattern == 4'b1101) begin
                    state <= 1; // SHIFTING state
                    pattern <= 0;
                end else if (data) begin
                    pattern <= {pattern[2:0], 1'b1};
                end else begin
                    pattern <= {pattern[2:0], 1'b0};
                end
            end
            1: begin // SHIFTING state
                delay <= {delay[2:0], data};
                state <= state + 1;
                if (state == 5) begin
                    state <= 2; // COUNTING state
                    remaining <= delay + 1;
                    counter <= 0;
                    counting <= 1;
                end
            end
            2: begin // COUNTING state
                counter <= counter + 1;
                if (counter == 1000) begin
                    counter <= 0;
                    remaining <= remaining - 1;
                    if (remaining == 0) begin
                        state <= 3; // DONE state
                        counting <= 0;
                        done <= 1;
                    end
                end
                count <= remaining;
            end
            3: begin // DONE state
                if (ack) begin
                    state <= 0; // IDLE state
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule