module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay;
reg [9:0] counter;
reg [3:0] pattern_reg;
reg [3:0] shift_counter;

parameter IDLE = 2'b00;
parameter SHIFT_IN = 2'b01;
parameter COUNTING = 2'b10;
parameter DONE = 2'b11;

reg [1:0] state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        delay <= 4'd0;
        counter <= 10'd0;
        pattern_reg <= 4'd0;
        shift_counter <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'd0;
    end
    else begin
        case (state)
            IDLE: begin
                if (data) begin
                    pattern_reg <= {pattern_reg[2:0], 1'b1};
                end
                else begin
                    pattern_reg <= {pattern_reg[2:0], 1'b0};
                end
                if (pattern_reg == 4'b1101) begin
                    state <= SHIFT_IN;
                    pattern_reg <= 4'd0;
                    shift_counter <= 4'd0;
                end
            end
            SHIFT_IN: begin
                if (shift_counter == 4'd0) begin
                    delay <= {data, 3'b000};
                end
                else if (shift_counter == 4'd1) begin
                    delay <= {delay[3:1], data};
                end
                else if (shift_counter == 4'd2) begin
                    delay <= {delay[3:2], data, 1'b0};
                end
                else if (shift_counter == 4'd3) begin
                    delay <= {delay[3:3], data, 2'b00};
                end
                shift_counter <= shift_counter + 1;
                if (shift_counter == 4'd4) begin
                    counter <= (delay + 1) * 1000;
                    state <= COUNTING;
                    counting <= 1'b1;
                end
            end
            COUNTING: begin
                if (counter > 1) begin
                    counter <= counter - 1;
                    if (counter % 1000 == 0) begin
                        count <= count - 1;
                    end
                end
                else begin
                    state <= DONE;
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule