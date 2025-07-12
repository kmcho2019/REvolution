module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] state;
reg [3:0] delay;
reg [3:0] remaining_time;
reg [3:0] shift_reg;
reg [3:0] counter;

// Define the states
localparam IDLE = 4'd0;
localparam SHIFT_DELAY = 4'd1;
localparam COUNTING = 4'd2;
localparam DONE = 4'd3;

// Define the pattern to be detected
localparam PATTERN = 4'b1101;

// Initialize the state machine
initial begin
    state = IDLE;
end

always @(posedge clk) begin
    if (reset) begin
        state = IDLE;
        shift_reg = 4'b0;
        delay = 4'd0;
        remaining_time = 4'd0;
        counter = 4'd0;
        count = 4'd0;
        counting = 1'b0;
        done = 1'b0;
    end else begin
        case (state)
            IDLE: begin
                // Detect the pattern 1101
                if (data == 1'b1) begin
                    shift_reg = {shift_reg[2:0], 1'b1};
                end else begin
                    shift_reg = {shift_reg[2:0], 1'b0};
                end
                if (shift_reg == PATTERN) begin
                    state = SHIFT_DELAY;
                    shift_reg = 4'b0;
                end
            end
            SHIFT_DELAY: begin
                // Shift in the delay bits
                shift_reg = {shift_reg[2:0], data};
                counter = counter + 1;
                if (counter == 4) begin
                    state = COUNTING;
                    delay = shift_reg;
                    remaining_time = delay;
                    counter = 4'd0;
                end
            end
            COUNTING: begin
                // Count down the delay
                count = remaining_time;
                counting = 1'b1;
                if (counter == 1000) begin
                    counter = 4'd0;
                    remaining_time = remaining_time - 1;
                    if (remaining_time == 0) begin
                        state = DONE;
                    end
                end else begin
                    counter = counter + 1;
                end
            end
            DONE: begin
                // Wait for the user to acknowledge the timer
                done = 1'b1;
                if (ack) begin
                    state = IDLE;
                    done = 1'b0;
                    counting = 1'b0;
                end
            end
        endcase
    end
end

endmodule