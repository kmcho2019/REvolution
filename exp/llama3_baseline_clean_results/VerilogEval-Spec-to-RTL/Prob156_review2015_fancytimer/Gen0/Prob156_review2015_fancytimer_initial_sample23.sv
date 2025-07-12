module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

// State register
reg [2:0] state;

// Delay register
reg [3:0] delay;

// Counter register
reg [19:0] counter;

// Pattern register
reg [3:0] pattern;

// Count register
reg [3:0] count_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        pattern <= 0;
        counting <= 0;
        done <= 0;
        count <= 0;
        count_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (pattern == 4'b1101) begin
                    state <= 1;
                    pattern <= 0;
                end else begin
                    pattern <= {pattern[2:0], data};
                end
            end
            1: begin // SHIFT state
                delay <= {delay[2:0], data};
                state <= (delay[3:0] == 0) ? 2 : 1;
                if (state == 2) begin
                    count_reg <= delay;
                    counter <= 0;
                    counting <= 1;
                end else begin
                    counting <= 0;
                end
            end
            2: begin // COUNT state
                counter <= counter + 1;
                if (counter == 1000) begin
                    count_reg <= count_reg - 1;
                    counter <= 0;
                    if (count_reg == 0) begin
                        state <= 3;
                        counting <= 0;
                    end
                end
                count <= count_reg;
            end
            3: begin // DONE state
                done <= 1;
                if (ack) begin
                    state <= 0;
                    done <= 0;
                    counting <= 0;
                end
            end
        endcase
    end
end

endmodule