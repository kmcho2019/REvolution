module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] state;
reg [3:0] delay;
reg [3:0] current_count;
reg [3:0] counter;
reg [3:0] pattern;
reg [3:0] shifted_pattern;

// state machine states
parameter IDLE = 4'b0000;
parameter DELAY = 4'b0001;
parameter COUNT = 4'b0010;
parameter DONE = 4'b0011;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        delay <= 4'b0000;
        current_count <= 4'b0000;
        counter <= 4'b0000;
        pattern <= 4'b0000;
        shifted_pattern <= 4'b0000;
        count <= 4'b0000;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case(state)
            IDLE: begin
                if (data) begin
                    pattern[3] <= 1'b1;
                end else begin
                    pattern[3] <= 1'b0;
                end
                pattern[2:0] <= pattern[3:1];
                if (pattern == 4'b1101) begin
                    state <= DELAY;
                end
            end
            DELAY: begin
                if (data) begin
                    shifted_pattern[3] <= 1'b1;
                end else begin
                    shifted_pattern[3] <= 1'b0;
                end
                shifted_pattern[2:0] <= shifted_pattern[3:1];
                if (shifted_pattern == 4'b0000) begin
                    delay[3] <= shifted_pattern[3];
                end else if (shifted_pattern == 4'b1000) begin
                    delay[2] <= shifted_pattern[3];
                end else if (shifted_pattern == 4'b0100) begin
                    delay[1] <= shifted_pattern[3];
                end else if (shifted_pattern == 4'b0010) begin
                    delay[0] <= shifted_pattern[3];
                    state <= COUNT;
                    counter <= {delay + 1'd1, 10'b0000000000};
                    current_count <= delay;
                    counting <= 1'b1;
                end
            end
            COUNT: begin
                counter <= counter - 1'b1;
                if (counter == 4'b0000) begin
                    current_count <= current_count - 1'b1;
                    if (current_count == 4'b0000) begin
                        state <= DONE;
                        done <= 1'b1;
                        counting <= 1'b0;
                    end else begin
                        counter <= {1'b1, 9'b111111111};
                    end
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    case(state)
        COUNT: begin
            if (counter[9] == 1'b1) begin
                count <= current_count;
            end
        end
        default: begin
            count <= 4'b0000;
        end
    endcase
end

endmodule