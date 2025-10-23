module Counter(
    input clk,
    input reset,
    input load,
    input [3:0] delay,
    output reg [3:0] count,
    output reg zero
);

reg [19:0] counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 20'd0;
        count <= 4'd0;
        zero <= 1'b0;
    end
    else if (load) begin
        counter <= (delay + 1) * 1000 - 1;
        count <= delay;
        zero <= 1'b0;
    end
    else if (counter > 20'd0) begin
        counter <= counter - 1;
        if (counter % 1000 == 999) begin
            count <= count - 1;
        end
        if (counter == 20'd0) begin
            zero <= 1'b1;
        end
    end
end

endmodule

module Control(
    input clk,
    input reset,
    input data,
    input ack,
    output reg [3:0] count,
    output reg counting,
    output reg done
);

reg [3:0] delay_reg;
reg [3:0] pattern;
reg [1:0] state;
reg [2:0] bit_counter;

parameter IDLE = 2'b00;
parameter PATTERN_DETECTION = 2'b01;
parameter DELAY_DETECTION = 2'b10;
parameter COUNTING = 2'b11;
parameter DONE_STATE = 2'b11;

wire zero;

Counter counter(
    .clk(clk),
    .reset(reset),
    .load(state == DELAY_DETECTION),
    .delay(delay_reg),
    .count(count),
    .zero(zero)
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        delay_reg <= 4'd0;
        pattern <= 4'd0;
        bit_counter <= 3'd0;
        counting <= 1'b0;
        done <= 1'b0;
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
                state <= COUNTING;
                counting <= 1'b1;
            end
            COUNTING: begin
                if (zero) begin
                    state <= DONE_STATE;
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            end
            DONE_STATE: begin
                if (ack) begin
                    state <= IDLE;
                    delay_reg <= 4'd0;
                    pattern <= 4'd0;
                    bit_counter <= 3'd0;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule

module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

Control control(
    .clk(clk),
    .reset(reset),
    .data(data),
    .ack(ack),
    .count(count),
    .counting(counting),
    .done(done)
);

endmodule