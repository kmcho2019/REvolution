module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] delay;
reg [3:0] counter;
reg [3:0] count_out;
reg [3:0] shift_reg;
reg [2:0] state;
reg [9:0] timer;

// State machine states
parameter IDLE = 3'b001;
parameter SHIFT = 3'b010;
parameter COUNT = 3'b011;
parameter DONE = 3'b100;
parameter WAIT = 3'b101;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        counter <= 4'b0;
        count_out <= 4'b0;
        delay <= 4'b0;
        timer <= 10'b0;
        shift_reg <= 4'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                // Search for pattern 1101
                if (shift_reg == 4'b1101) begin
                    state <= SHIFT;
                    shift_reg <= 4'b0;
                end else begin
                    shift_reg <= {shift_reg[2:0], data};
                end
            end
            SHIFT: begin
                // Shift in next 4 bits
                shift_reg <= {shift_reg[2:0], data};
                if (shift_reg == 4'b1000) begin
                    delay <= shift_reg;
                    state <= COUNT;
                    counter <= delay + 1;
                    timer <= 10'b0;
                    counting <= 1'b1;
                end
            end
            COUNT: begin
                // Count down from specified duration
                if (timer == 10'b1111101000) begin
                    timer <= 10'b0;
                    if (counter > 1) begin
                        counter <= counter - 1;
                    end else begin
                        state <= DONE;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end
                end else begin
                    timer <= timer + 1;
                end
                count_out <= counter - 1;
            end
            DONE: begin
                // Notify user and wait for ack
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

assign count = (state == COUNT) ? count_out : 4'bxxxx;

endmodule