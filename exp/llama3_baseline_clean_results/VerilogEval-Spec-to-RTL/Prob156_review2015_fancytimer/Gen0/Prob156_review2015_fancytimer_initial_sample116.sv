module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state;
reg [3:0] delay;
reg [3:0] counter;
reg [9:0] clock_counter;
reg start_pattern;
reg [3:0] shift_counter;

// State definitions
parameter IDLE = 4'b0000;
parameter SHIFT = 4'b0001;
parameter COUNTING = 4'b0010;
parameter DONE = 4'b0011;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_pattern <= 1'b0;
        shift_counter <= 4'b0000;
        delay <= 4'b0000;
        counter <= 4'b0000;
        clock_counter <= 10'b0000000000;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (start_pattern == 1'b1) begin
                    state <= SHIFT;
                    shift_counter <= 4'b0000;
                end else begin
                    if (data == 1'b1) begin
                        start_pattern <= 1'b1;
                    end else begin
                        start_pattern <= 1'b0;
                    end
                end
            end
            SHIFT: begin
                if (shift_counter == 4'b1000) begin
                    state <= COUNTING;
                    counter <= delay;
                    clock_counter <= 10'b0000000000;
                    counting <= 1'b1;
                end else begin
                    delay[shift_counter] <= data;
                    shift_counter <= shift_counter + 1'b1;
                end
            end
            COUNTING: begin
                if (clock_counter == 10'b1111101000) begin
                    clock_counter <= 10'b0000000000;
                    counter <= counter - 1'b1;
                    if (counter == 4'b0000) begin
                        state <= DONE;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end
                end else begin
                    clock_counter <= clock_counter + 1'b1;
                end
                count <= counter;
            end
            DONE: begin
                if (ack == 1'b1) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule