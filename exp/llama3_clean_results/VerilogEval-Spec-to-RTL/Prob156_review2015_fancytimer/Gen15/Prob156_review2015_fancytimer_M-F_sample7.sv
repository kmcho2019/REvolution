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
reg [19:0] counter;
reg [3:0] remaining_time;

parameter IDLE = 3'b000;
parameter DELAY_SHIFT = 3'b001;
parameter COUNTING = 3'b010;
parameter DONE_STATE = 3'b011;

reg [2:0] state;
reg [3:0] shift_reg;
reg [1:0] shift_count;

// Module to handle the state transitions
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        delay_reg <= 4'd0;
        counter <= 20'd0;
        remaining_time <= 4'd0;
        count <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
        shift_reg <= 4'd0;
        shift_count <= 2'd0;
    end
    else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    if (shift_count == 2'd0) begin
                        shift_reg <= {data, 3'b0};
                    end
                    else if (shift_count == 2'd1) begin
                        shift_reg <= {shift_reg[2:0], data};
                    end
                    else if (shift_count == 2'd2) begin
                        shift_reg <= {shift_reg[1:0], data};
                    end
                    else if (shift_count == 2'd3) begin
                        shift_reg <= {shift_reg[0], data, 2'b0};
                    end
                    shift_count <= shift_count + 1;
                    if (shift_count == 2'd4) begin
                        if (shift_reg == 4'b1101) begin
                            state <= DELAY_SHIFT;
                            shift_count <= 2'd0;
                        end
                        else begin
                            shift_count <= 2'd0;
                        end
                    end
                end
                else begin
                    shift_reg <= 4'd0;
                    shift_count <= 2'd0;
                end
            end
            DELAY_SHIFT: begin
                if (shift_count == 2'd0) begin
                    delay_reg <= {data, 3'b0};
                end
                else if (shift_count == 2'd1) begin
                    delay_reg <= {delay_reg[2:0], data};
                end
                else if (shift_count == 2'd2) begin
                    delay_reg <= {delay_reg[1:0], data};
                end
                else if (shift_count == 2'd3) begin
                    delay_reg <= {delay_reg[0], data};
                    state <= COUNTING;
                    counter <= (delay_reg + 1) * 1000 - 1;
                    remaining_time <= delay_reg;
                    counting <= 1'b1;
                end
                shift_count <= shift_count + 1;
            end
            COUNTING: begin
                if (counter > 20'd0) begin
                    counter <= counter - 1;
                    if (counter % 1000 == 999) begin
                        remaining_time <= remaining_time - 1;
                    end
                end
                else begin
                    state <= DONE_STATE;
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            end
            DONE_STATE: begin
                if (ack) begin
                    state <= IDLE;
                    counter <= 20'd0;
                    delay_reg <= 4'd0;
                    remaining_time <= 4'd0;
                    count <= 4'd0;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

// Module to handle the output signals
always @(*) begin
    if (state == COUNTING) begin
        count = remaining_time;
    end
    else begin
        count = 4'bx;
    end
end

endmodule