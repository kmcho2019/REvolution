module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

reg [3:0] delay; // delay value
reg [9:0] counter; // counter for 1000 cycles
reg [3:0] remaining; // remaining time
reg [3:0] state; // state of the FSM
reg [3:0] pattern; // pattern to be matched

always @(posedge clk) begin
    if (reset) begin
        // Reset the FSM to the initial state
        state <= 4'b0000;
        pattern <= 4'b0000;
        delay <= 4'b0000;
        counter <= 10'b0;
        remaining <= 4'b0000;
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'b0000;
    end else begin
        case (state)
            4'b0000: begin // Searching for the start pattern
                if (data == 1'b1) begin
                    pattern[0] <= 1'b1;
                    pattern[3:1] <= pattern[2:0];
                end else begin
                    pattern <= 4'b0000;
                end
                if (pattern == 4'b1101) begin
                    state <= 4'b0001;
                end
            end
            4'b0001: begin // Shifting in the delay
                delay[0] <= data;
                delay[3:1] <= delay[2:0];
                state <= state + 1'b1;
                if (state == 4'b0101) begin
                    state <= 4'b0010;
                    counter <= 10'b0;
                    remaining <= delay + 1'b1;
                end
            end
            4'b0010: begin // Counting down
                counting <= 1'b1;
                if (counter == 10'b1111101000) begin
                    counter <= 10'b0;
                    remaining <= remaining - 1'b1;
                    if (remaining == 4'b0000) begin
                        state <= 4'b0011;
                        done <= 1'b1;
                        counting <= 1'b0;
                    end
                end else begin
                    counter <= counter + 1'b1;
                end
                count <= remaining;
            end
            4'b0011: begin // Waiting for acknowledgment
                if (ack == 1'b1) begin
                    state <= 4'b0000;
                    done <= 1'b0;
                end
            end
            default: state <= 4'b0000;
        endcase
    end
end

endmodule