module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] state;
reg [3:0] delay;
reg [3:0] curr_count;
reg [9:0] counter;
reg pattern_detected;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        pattern_detected <= 0;
        delay <= 0;
        curr_count <= 0;
        counter <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // searching for pattern
                if (data) begin
                    if (pattern_detected == 1'b1) begin
                        pattern_detected <= 1'b0;
                        delay[0] <= 1'b1;
                    end else if (pattern_detected == 1'b0) begin
                        pattern_detected <= 1'b1;
                    end
                end else if (pattern_detected == 1'b1) begin
                    pattern_detected <= 1'b0;
                end
                if (pattern_detected == 4'b1101) begin
                    state <= 1;
                    pattern_detected <= 0;
                end
            end
            1: begin // shifting in delay
                delay[3:1] <= {delay[2:0], data};
                if (delay[0]) begin
                    state <= 2;
                    curr_count <= delay + 1;
                    counter <= 0;
                    counting <= 1;
                end
            end
            2: begin // counting
                if (counter < 1000) begin
                    counter <= counter + 1;
                    count <= curr_count;
                end else begin
                    counter <= 0;
                    curr_count <= curr_count - 1;
                    if (curr_count == 0) begin
                        state <= 3;
                        counting <= 0;
                        done <= 1;
                    end
                end
            end
            3: begin // waiting for ack
                if (ack) begin
                    state <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule