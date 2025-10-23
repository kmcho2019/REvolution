module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay;
reg [15:0] counter;
reg [3:0] state;
reg [3:0] shift_counter;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        shift_counter <= 0;
        counter <= 0;
        delay <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (data == 1) begin
                    state <= 1;
                end
            end
            1: begin // Looking for second 1 in pattern
                if (data == 1) begin
                    state <= 2;
                end else if (data == 0) begin
                    state <= 0;
                end
            end
            2: begin // Looking for 0 in pattern
                if (data == 0) begin
                    state <= 3;
                end else if (data == 1) begin
                    state <= 0;
                end
            end
            3: begin // Looking for last 1 in pattern
                if (data == 1) begin
                    state <= 4;
                end else if (data == 0) begin
                    state <= 0;
                end
            end
            4: begin // Shift in delay
                if (shift_counter < 4) begin
                    delay[3 - shift_counter] <= data;
                    shift_counter <= shift_counter + 1;
                end else begin
                    state <= 5;
                    shift_counter <= 0;
                    counter <= ((delay + 1) * 1000) - 1;
                    counting <= 1;
                end
            end
            5: begin // Count down
                if (counter > 0) begin
                    counter <= counter - 1;
                    if (counter % 1000 == 0) begin
                        count <= count - 1;
                    end
                end else begin
                    state <= 6;
                    counting <= 0;
                    count <= 0;
                end
            end
            6: begin // Done
                done <= 1;
                if (ack) begin
                    state <= 0;
                    done <= 0;
                end
            end
            default: state <= 0;
        endcase
    end
end

always @(*) begin
    if (state == 5) begin
        count <= delay - (999 - (counter % 1000)) / 1000;
    end else begin
        count <= 0;
    end
end

endmodule