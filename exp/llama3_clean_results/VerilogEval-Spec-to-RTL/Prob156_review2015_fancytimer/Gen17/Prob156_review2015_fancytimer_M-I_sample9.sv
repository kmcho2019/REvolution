module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [1:0] state;
reg [3:0] delay;
reg [3:0] pattern_reg;
reg [19:0] counter;

// State machine
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        delay <= 0;
        pattern_reg <= 0;
        counter <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data == 1'b1) begin
                    pattern_reg <= {data, pattern_reg[2:0]};
                    if (pattern_reg == 4'b1101) begin
                        state <= 1;
                    end
                end else begin
                    pattern_reg <= {data, pattern_reg[2:0]};
                end
            end
            1: begin // SHIFT_PAT
                pattern_reg <= {data, pattern_reg[2:0]};
                if (pattern_reg == 4'b1101) begin
                    state <= 2;
                end
            end
            2: begin // SHIFT_COUNT
                delay <= {data, delay[2:0]};
                if (delay!= 0) begin
                    state <= 2;
                end else begin
                    counter <= (delay + 1) * 1000 - 1;
                    counting <= 1;
                    state <= 3;
                end
            end
            3: begin // DONE
                if (counter > 0) begin
                    counter <= counter - 1;
                    if (counter % 1000 == 0) begin
                        delay <= delay - 1;
                    end
                end else begin
                    counting <= 0;
                    done <= 1;
                    if (ack == 1'b1) begin
                        state <= 0;
                        done <= 0;
                    end
                end
            end
        endcase
    end
end

// Assign outputs
assign count = (state == 3)? delay : 4'bxxxx;

endmodule