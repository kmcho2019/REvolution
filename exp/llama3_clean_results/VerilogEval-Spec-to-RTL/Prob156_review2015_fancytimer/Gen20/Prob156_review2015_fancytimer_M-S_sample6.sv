module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [2:0] state; // 0: Idle, 1: Capture, 2: Counting, 3: Done
reg [3:0] delay;
reg [19:0] counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        counter <= 0;
        delay <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case(state)
            0: begin // Idle
                if (data == 1) begin
                    state <= 1;
                end
            end
            1: begin // Capture
                delay <= {delay[2:0], data};
                if (delay[3] == 1) begin
                    state <= 2;
                    counter <= (delay + 1) * 1000 - 1;
                end
            end
            2: begin // Counting
                if (counter > 0) begin
                    counter <= counter - 1;
                    counting <= 1;
                end else begin
                    state <= 3;
                    counting <= 0;
                end
            end
            3: begin // Done
                done <= 1;
                if (ack == 1'b1) begin
                    state <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

assign count = (state == 2)? (counter / 1000) : 0;

endmodule