module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] delay;
reg [3:0] curr_count;
reg [9:0] clock_cycles;
reg [3:0] remaining_time;
reg [3:0] pattern;
reg start;
reg [1:0] state;

// Initialize the state machine
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        start <= 0;
        counting <= 0;
        done <= 0;
        pattern <= 0;
        curr_count <= 0;
        clock_cycles <= 0;
        remaining_time <= 0;
    end else begin
        case (state)
            0: begin // searching for input pattern
                if (data == 1 && pattern == 4'b1101) begin
                    start <= 1;
                    state <= 1;
                end else if (data == 1) begin
                    pattern <= {pattern[2:0], 1'b1};
                end else if (data == 0) begin
                    pattern <= {pattern[2:0], 1'b0};
                end
            end
            1: begin // shifting in delay bits
                delay <= {delay[2:0], data};
                if (delay[0] == 1'b1) begin // most significant bit is 1
                    state <= 2;
                end
            end
            2: begin // counting
                counting <= 1;
                clock_cycles <= clock_cycles + 1;
                if (clock_cycles == 1000) begin
                    remaining_time <= remaining_time - 1;
                    clock_cycles <= 0;
                    if (remaining_time == 0) begin
                        state <= 3;
                        done <= 1;
                        counting <= 0;
                    end
                end
                count <= remaining_time;
            end
            3: begin // waiting for ack
                if (ack == 1) begin
                    state <= 0;
                    done <= 0;
                    start <= 0;
                    pattern <= 0;
                    curr_count <= 0;
                    clock_cycles <= 0;
                    remaining_time <= 0;
                end
            end
        endcase
    end
end

// load the delay value and set the remaining time
always @(posedge clk) begin
    if (start) begin
        remaining_time <= delay + 1;
        start <= 0;
    end
end

endmodule