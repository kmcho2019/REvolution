module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay_reg;
reg [19:0] cycle_counter;
reg [3:0] pattern;
reg [2:0] state;
reg [2:0] bit_counter;
reg [3:0] current_count;

parameter IDLE = 3'b000;
parameter DELAY_DETECTION = 3'b001;
parameter COUNTDOWN = 3'b010;
parameter DONE_WAIT = 3'b011;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        delay_reg <= 4'd0;
        cycle_counter <= 20'd0;
        pattern <= 4'd0;
        bit_counter <= 3'd0;
        count <= 4'd0;
        done <= 1'b0;
        counting <= 1'b0;
        current_count <= 4'd0;
    end
    else begin
        case (state)
            IDLE: begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    state <= DELAY_DETECTION;
                    pattern <= 4'd0;
                    bit_counter <= 3'd0;
                end
            end
            DELAY_DETECTION: begin
                if (bit_counter < 3'd4) begin
                    delay_reg <= {data, delay_reg[3:1]};
                    bit_counter <= bit_counter + 1;
                end
                if (bit_counter == 3'd4) begin
                    state <= COUNTDOWN;
                    cycle_counter <= 20'd0;
                    current_count <= delay_reg;
                    counting <= 1'b1;
                end
            end
            COUNTDOWN: begin
                cycle_counter <= cycle_counter + 1;
                if (cycle_counter == 20'd999) begin
                    cycle_counter <= 20'd0;
                    current_count <= current_count - 1;
                end
                if (current_count == 4'd0) begin
                    state <= DONE_WAIT;
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            end
            DONE_WAIT: begin
                if (ack) begin
                    state <= IDLE;
                    cycle_counter <= 20'd0;
                    delay_reg <= 4'd0;
                    pattern <= 4'd0;
                    bit_counter <= 3'd0;
                    done <= 1'b0;
                end
            end
        endcase
        if (state == COUNTDOWN) begin
            count <= current_count;
        end
        else begin
            count <= 4'd0;
        end
    end
end

endmodule