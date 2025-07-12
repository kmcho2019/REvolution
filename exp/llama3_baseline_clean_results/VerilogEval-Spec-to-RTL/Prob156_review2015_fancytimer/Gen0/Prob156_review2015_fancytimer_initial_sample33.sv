module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state;
reg [3:0] delay;
reg [3:0] remaining;
reg [11:0] counter;
reg start;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        start <= 0;
        delay <= 0;
        remaining <= 0;
        counter <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data == 1) begin
                    start <= 1;
                end else begin
                    start <= 0;
                end
                if (start == 1 && data == 1) begin
                    state <= 1;
                    start <= 0;
                end else if (start == 1 && data == 0) begin
                    start <= 0;
                end
            end
            1: begin // IDLE (checking for 110)
                if (data == 1) begin
                    state <= 2;
                end else if (data == 0) begin
                    state <= 0;
                    start <= 0;
                end
            end
            2: begin // IDLE (checking for 1101)
                if (data == 0) begin
                    state <= 3;
                end else if (data == 1) begin
                    state <= 0;
                    start <= 0;
                end
            end
            3: begin // SHIFT_DELAY
                delay[3] <= data;
                state <= 4;
            end
            4: begin // SHIFT_DELAY
                delay[2] <= data;
                state <= 5;
            end
            5: begin // SHIFT_DELAY
                delay[1] <= data;
                state <= 6;
            end
            6: begin // SHIFT_DELAY
                delay[0] <= data;
                state <= 7;
                remaining <= delay;
                counter <= 0;
                counting <= 1;
            end
            7: begin // COUNT_DOWN
                if (counter < 1000) begin
                    counter <= counter + 1;
                end else begin
                    counter <= 0;
                    if (remaining > 0) begin
                        remaining <= remaining - 1;
                    end else begin
                        counting <= 0;
                        done <= 1;
                        state <= 8;
                    end
                end
                count <= remaining;
            end
            8: begin // DONE
                if (ack == 1) begin
                    state <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule