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
reg pattern_detected;

parameter IDLE = 2'b00;
parameter COUNTING = 2'b01;
parameter DONE_STATE = 2'b10;

reg [1:0] state;

// Module to detect the input pattern
reg [3:0] pattern_reg;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        pattern_reg <= 4'd0;
    end
    else begin
        pattern_reg <= {data, pattern_reg[3:1]};
    end
end

// Module to handle the counting functionality
always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 20'd0;
        remaining_time <= 4'd0;
    end
    else if (state == COUNTING) begin
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
end

// Module to handle the state transitions
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        delay_reg <= 4'd0;
        pattern_detected <= 1'b0;
        count <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (pattern_reg == 4'b1101) begin
                    pattern_detected <= 1'b1;
                    // Shift in the next 4 bits
                    delay_reg <= {data, delay_reg[3:1]};
                    if (delay_reg == 4'b0000) begin
                        // Start counting
                        counter <= (delay_reg + 1) * 1000 - 1;
                        remaining_time <= delay_reg;
                        state <= COUNTING;
                        counting <= 1'b1;
                    end
                end
            end
            COUNTING: begin
                // No action needed
            end
            DONE_STATE: begin
                if (ack) begin
                    state <= IDLE;
                    counter <= 20'd0;
                    delay_reg <= 4'd0;
                    remaining_time <= 4'd0;
                    pattern_reg <= 4'd0;
                    pattern_detected <= 1'b0;
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