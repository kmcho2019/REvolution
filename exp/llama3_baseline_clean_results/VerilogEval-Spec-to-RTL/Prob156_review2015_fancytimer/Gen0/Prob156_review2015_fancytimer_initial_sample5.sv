module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

// State machine states
enum logic [2:0] {
    Idle,
    Shift,
    Count,
    DoneWait
} state, nextState;

// Shift register to store the delay value
logic [3:0] delay;
logic [3:0] delay_shift;
logic [3:0] delay_counter;
logic [9:0] count_counter;

// Flag to indicate if the start sequence has been detected
logic start_detected;

// Flag to indicate if the ack signal has been asserted
logic ack_asserted;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        delay <= 4'b0;
        count_counter <= 10'b0;
        ack_asserted <= 1'b0;
        delay_counter <= 4'b0;
    end else begin
        case (state)
            Idle: begin
                // Check if the start sequence has been detected
                if (data && start_detected) begin
                    state <= Shift;
                    start_detected <= 1'b0;
                end else if (data) begin
                    start_detected <= 1'b1;
                end else begin
                    start_detected <= 1'b0;
                end
            end
            Shift: begin
                // Shift in the delay value
                delay_shift <= {data, delay_shift[3:1]};
                if (delay_shift[3] == 1'b1) begin
                    delay <= delay_shift;
                    state <= Count;
                end
            end
            Count: begin
                // Count for the specified delay
                count_counter <= count_counter + 1'b1;
                if (count_counter == 10'd999) begin
                    count_counter <= 10'b0;
                    delay_counter <= delay_counter - 1'b1;
                    if (delay_counter == 4'b0) begin
                        state <= DoneWait;
                    end
                end
            end
            DoneWait: begin
                // Wait for the ack signal to be asserted
                if (ack) begin
                    ack_asserted <= 1'b1;
                    state <= Idle;
                end
            end
        endcase
    end
end

always_comb begin
    counting = (state == Count) ? 1'b1 : 1'b0;
    done = (state == DoneWait) ? 1'b1 : 1'b0;
    if (state == Count) begin
        count = delay_counter;
    end else begin
        count = 4'bxxxx;
    end
end

endmodule