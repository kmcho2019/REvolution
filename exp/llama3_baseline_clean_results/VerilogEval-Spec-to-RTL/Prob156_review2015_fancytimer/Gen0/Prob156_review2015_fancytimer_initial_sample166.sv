module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

reg [3:0] state; // 0: IDLE, 1: SHIFT, 2: COUNTING, 3: DONE
reg [3:0] delay; // delay value
reg [3:0] remaining_count; // remaining count value
reg [11:0] counter; // counter for 1000 clock cycles

always @(posedge clk) begin
    if (reset) begin // reset to IDLE state
        state <= 0;
        done <= 0;
        counting <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (data) begin // check for start sequence
                    if (delay[3:0] == 4'b1101) begin
                        state <= 1;
                        delay[3:0] <= 0;
                    end
                end
            end
            1: begin // SHIFT state
                delay[3:0] <= {data, delay[3:0][2:0]}; // shift in next bit
                if (delay[3:0] == 4'b1) begin // all bits shifted in
                    state <= 2;
                    remaining_count <= delay + 1;
                    counter <= 12'd999; // 1000 clock cycles - 1
                    counting <= 1;
                end
            end
            2: begin // COUNTING state
                if (counter == 0) begin // 1000 clock cycles passed
                    if (remaining_count > 1) begin
                        remaining_count <= remaining_count - 1;
                        counter <= 12'd999; // 1000 clock cycles - 1
                    end else begin
                        state <= 3;
                        counting <= 0;
                        done <= 1;
                    end
                end else begin
                    counter <= counter - 1;
                end
            end
            3: begin // DONE state
                if (ack) begin // ack received
                    state <= 0; // reset to IDLE state
                    done <= 0;
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        0, 1, 3: count = 4'bxxxx; // don't care when not counting
        2: count = remaining_count - 1; // output remaining count
    endcase
end

endmodule