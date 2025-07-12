module TopModule (
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] delay;  // Store the delay value
reg [3:0] counter;  // Store the current count value
reg [9:0] timer;  // Store the remaining time
reg [3:0] shift_reg;  // Store the shifted bits
reg found_start;  // Flag to indicate if the start pattern is found
reg counting_out;
reg done_out;

// Enum for the states
enum logic [1:0] {IDLE, SHIFT, COUNT, DONE} state, next_state;

always_comb begin
    // Default values
    next_state = state;
    counting_out = 1'b0;
    done_out = 1'b0;

    case (state)
        IDLE: begin
            if (reset) begin
                next_state = IDLE;
            end else if (found_start) begin
                next_state = SHIFT;
            end
        end
        SHIFT: begin
            if (shift_reg == 4'd15) begin
                next_state = COUNT;
            end
        end
        COUNT: begin
            if (timer == 10'd0) begin
                next_state = DONE;
            end
            counting_out = 1'b1;
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end
            done_out = 1'b1;
        end
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        found_start <= 1'b0;
        shift_reg <= 4'd0;
        delay <= 4'd0;
        counter <= 4'd0;
        timer <= 10'd0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                // Check for the start pattern 1101
                if (data) begin
                    found_start <= 1'b1;
                end else begin
                    found_start <= 1'b0;
                end
            end
            SHIFT: begin
                // Shift in the next 4 bits
                shift_reg <= shift_reg + 1'b1;
                delay <= {data, delay[3:1]};
            end
            COUNT: begin
                // Count for exactly (delay[3:0] + 1) * 1000 clock cycles
                if (timer == 10'd0) begin
                    counter <= counter - 1'b1;
                    timer <= (counter == 4'd0)? 10'd0 : 10'd1000;
                end else begin
                    timer <= timer - 1'b1;
                end
            end
            DONE: begin
                // Wait for the ack signal
            end
        endcase
    end
end

assign count = (state == COUNT)? counter : 4'd0;
assign counting = counting_out;
assign done = done_out;

endmodule