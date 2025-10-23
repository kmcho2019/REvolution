module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

reg [3:0] state;  // state machine states: 0 - IDLE, 1 - SHIFT, 2 - COUNTING, 3 - DONE
reg [3:0] delay;  // delay value
reg [3:0] counter;  // counter for counting
reg [9:0] cycles;  // counter for clock cycles

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        delay <= 0;
        counter <= 0;
        cycles <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin  // IDLE
                if (data == 1) begin  // start searching for the input pattern
                    state <= 1;
                end
            end
            1: begin  // first bit of pattern
                if (data == 1) begin
                    state <= 2;
                end else begin
                    state <= 0;
                end
            end
            2: begin  // second bit of pattern
                if (data == 0) begin
                    state <= 3;
                end else begin
                    state <= 0;
                end
            end
            3: begin  // third bit of pattern
                if (data == 1) begin
                    state <= 4;
                end else begin
                    state <= 0;
                end
            end
            4: begin  // fourth bit of pattern and start shifting delay
                if (data == 1) begin
                    delay[3] <= 1;
                    state <= 5;
                end else begin
                    delay[3] <= 0;
                    state <= 5;
                end
            end
            5: begin  // shifting delay
                delay[2] <= data;
                state <= 6;
            end
            6: begin
                delay[1] <= data;
                state <= 7;
            end
            7: begin
                delay[0] <= data;
                state <= 8;
                counter <= delay + 1;
                cycles <= 0;
                count <= delay;
                counting <= 1;
            end
            8: begin  // COUNTING
                if (cycles == 999) begin
                    cycles <= 0;
                    if (counter > 1) begin
                        counter <= counter - 1;
                        count <= count - 1;
                    end else begin
                        counting <= 0;
                        state <= 9;
                    end
                end else begin
                    cycles <= cycles + 1;
                end
            end
            9: begin  // DONE
                done <= 1;
                if (ack) begin
                    state <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule