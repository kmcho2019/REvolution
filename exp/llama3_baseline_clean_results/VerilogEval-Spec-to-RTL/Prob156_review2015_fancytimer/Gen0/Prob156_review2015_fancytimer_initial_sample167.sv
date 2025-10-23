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
reg [3:0] counter;
reg [3:0] remaining;
reg [1:0] state;
reg [3:0] shift_counter;
reg start_pattern;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        start_pattern <= 1'b0;
        shift_counter <= 4'b0000;
        counter <= 4'b0000;
        remaining <= 4'b0000;
        delay <= 4'b0000;
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'b0000;
    end else begin
        case (state)
            0: begin // IDLE
                if (data == 1'b1 && start_pattern == 1'b0) begin
                    start_pattern <= 1'b1;
                end else if (data == 1'b0 && start_pattern == 1'b1) begin
                    start_pattern <= 1'b0;
                end else if (start_pattern == 1'b1 && data == 1'b1) begin
                    state <= 1; // SHIFTING
                    shift_counter <= 4'b1000;
                    delay <= 4'b0000;
                end
            end
            1: begin // SHIFTING
                delay[3] <= data;
                shift_counter <= shift_counter - 1;
                if (shift_counter == 4'b0000) begin
                    state <= 2; // COUNTING
                    counter <= 4'b0000;
                    remaining <= delay + 1;
                    counting <= 1'b1;
                end else begin
                    case (shift_counter)
                        4'b0111: delay[2] <= data;
                        4'b0101: delay[1] <= data;
                        4'b0011: delay[0] <= data;
                    endcase
                end
            end
            2: begin // COUNTING
                if (counter == 10'b1111111111) begin
                    counter <= 4'b0000;
                    remaining <= remaining - 1;
                    if (remaining == 4'b0000) begin
                        state <= 3; // DONE
                        counting <= 1'b0;
                    end
                end else begin
                    counter <= counter + 1;
                end
                count <= remaining;
            end
            3: begin // DONE
                done <= 1'b1;
                if (ack == 1'b1) begin
                    state <= 0; // IDLE
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule