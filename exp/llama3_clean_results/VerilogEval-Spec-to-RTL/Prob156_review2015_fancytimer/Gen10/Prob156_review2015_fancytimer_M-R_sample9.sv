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
reg [3:0] pattern;
reg [2:0] state;
reg [2:0] next_state;
reg [3:0] remaining_time;
reg [3:0] next_remaining_time;

parameter IDLE = 3'b001;
parameter DELAY_DETECTION = 3'b010;
parameter COUNTING = 3'b100;
parameter DONE = 3'b111;

// Output assignments
assign counting = (state == COUNTING);
assign done = (state == DONE);

// Next state logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        next_state <= IDLE;
        next_remaining_time <= 4'd0;
    end
    else begin
        case (state)
            IDLE: begin
                if (pattern == 4'b1101) begin
                    next_state <= DELAY_DETECTION;
                    next_remaining_time <= 4'd0;
                end
                else begin
                    next_state <= IDLE;
                    next_remaining_time <= 4'd0;
                end
            end
            DELAY_DETECTION: begin
                // Check if 4 bits have been shifted into the delay register
                if (delay_reg[3] == 1'b1) begin
                    next_state <= COUNTING;
                    next_remaining_time <= delay_reg;
                end
                else begin
                    next_state <= DELAY_DETECTION;
                    next_remaining_time <= 4'd0;
                end
            end
            COUNTING: begin
                if (counter > 20'd0) begin
                    next_state <= COUNTING;
                    if (counter % 1000 == 20'd999) begin
                        next_remaining_time <= remaining_time - 1;
                    end
                    else begin
                        next_remaining_time <= remaining_time;
                    end
                end
                else begin
                    next_state <= DONE;
                    next_remaining_time <= 4'd0;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state <= IDLE;
                    next_remaining_time <= 4'd0;
                end
                else begin
                    next_state <= DONE;
                    next_remaining_time <= 4'd0;
                end
            end
        endcase
    end
end

// State and register updates
always @(posedge clk) begin
    state <= next_state;
    remaining_time <= next_remaining_time;
    if (state == IDLE) begin
        pattern <= {pattern[2:0], data};
    end
    else if (state == DELAY_DETECTION) begin
        delay_reg <= {delay_reg[2:0], data};
    end
    else if (state == COUNTING) begin
        counter <= counter - 1;
    end
    else if (state == DONE) begin
        counter <= 20'd0;
        delay_reg <= 4'd0;
        pattern <= 4'd0;
    end
end

// Count output assignment
always @(*) begin
    if (state == COUNTING) begin
        count = remaining_time;
    end
    else begin
        count = 4'd0; // Don't care
    end
end

endmodule