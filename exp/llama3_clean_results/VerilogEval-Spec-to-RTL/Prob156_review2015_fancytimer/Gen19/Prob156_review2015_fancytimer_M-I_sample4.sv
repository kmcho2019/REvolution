module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [2:0] state; // Reduced number of states
reg [3:0] delay;
reg [9:0] counter; // Reduced counter size
reg [3:0] remaining_time;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        delay <= 0;
        counter <= 0;
        remaining_time <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // Idle state
                if (data == 1'b1) begin // Receive first bit of pattern
                    state <= 1;
                end
            end
            1: begin // Receive second and third bit of pattern
                if (data == 1'b1) begin // Receive second bit of pattern
                    if (state == 1) begin
                        state <= 2;
                    end else if (state == 2 && data == 0'b0) begin // Receive third bit of pattern
                        state <= 3;
                    end
                end else begin
                    state <= 0; // Reset to idle state
                end
            end
            2: begin // Receive fourth bit of pattern and shift in delay
                if (data == 1'b1) begin // Receive fourth bit of pattern
                    state <= 4; // Start counting
                    delay <= 0;
                    counter <= 0;
                end else begin
                    state <= 0; // Reset to idle state
                end
            end
            3: begin // Shift in delay
                if (counter < 4) begin
                    delay <= {data, delay[3:1]};
                    counter <= counter + 1;
                end else begin
                    state <= 4; // Start counting
                    counter <= (delay + 1) * 1000 - 1;
                    remaining_time <= delay;
                    counting <= 1;
                end
            end
            4: begin // Counting state
                if (counter > 0) begin
                    counter <= counter - 1;
                    if (counter % 1000 == 0) begin
                        remaining_time <= remaining_time - 1;
                    end
                end else begin
                    state <= 5; // Timeout notification state
                    counting <= 0;
                    done <= 1;
                end
            end
            5: begin // Timeout notification state
                if (ack == 1'b1) begin
                    state <= 0; // Reset to idle state
                    done <= 0;
                end
            end
        endcase
    end
end

assign count = remaining_time;

endmodule