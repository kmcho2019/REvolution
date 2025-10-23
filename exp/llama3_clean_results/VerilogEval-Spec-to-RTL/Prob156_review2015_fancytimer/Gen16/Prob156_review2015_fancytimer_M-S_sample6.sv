module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [19:0] counter;
reg [3:0] delay_reg;
reg [3:0] pattern;
reg [2:0] state;
reg [2:0] bit_counter;

parameter IDLE = 3'b000;
parameter PATTERN_DETECTION = 3'b001;
parameter DELAY_DETECTION = 3'b010;
parameter COUNTING = 3'b011;
parameter DONE_STATE = 3'b100;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        delay_reg <= 4'd0;
        pattern <= 4'd0;
        bit_counter <= 3'd0;
        counter <= 20'd0;
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'd0;
    end
    else begin
        case (state)
            IDLE: begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    state <= PATTERN_DETECTION;
                    pattern <= 4'd0;
                    bit_counter <= 3'd0;
                end
            end
            PATTERN_DETECTION: begin
                if (bit_counter < 3'd4) begin
                    delay_reg <= {data, delay_reg[3:1]};
                    bit_counter <= bit_counter + 1;
                end
                if (bit_counter == 3'd4) begin
                    state <= DELAY_DETECTION;
                end
            end
            DELAY_DETECTION: begin
                counter <= (delay_reg + 1) * 1000;
                count <= delay_reg;
                state <= COUNTING;
                counting <= 1'b1;
            end
            COUNTING: begin
                if (counter > 20'd0) begin
                    counter <= counter - 1;
                    if (counter % 1000 == 0 && counter != 20'd0) begin
                        count <= count - 1;
                    end
                    if (counter == 20'd0) begin
                        state <= DONE_STATE;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end
                end
            end
            DONE_STATE: begin
                if (ack) begin
                    state <= IDLE;
                    delay_reg <= 4'd0;
                    pattern <= 4'd0;
                    bit_counter <= 3'd0;
                    counter <= 20'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            end
        endcase
    end
end

endmodule