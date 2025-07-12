module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output [9:0] data_out
);

// States: IDLE (waiting for first input), ACCUM (accumulating inputs)
typedef enum {IDLE, ACCUM} state_t;
reg state, next_state;

// Counter (1-bit since we only need to count mod 4)
reg counter, next_counter;

// Accumulator
reg [9:0] accum, next_accum;

// Output assignment
assign data_out = accum + data_in;

// State transition and accumulation logic
always @(*) begin
    // Defaults
    next_state = state;
    next_counter = counter;
    next_accum = accum;
    valid_out = 1'b0;

    if (valid_in) begin
        case (state)
            IDLE: begin
                // First valid input
                next_state = ACCUM;
                next_accum = data_in;
                next_counter = 1'b0;
            end
            ACCUM: begin
                if (counter) begin
                    // 4th input (counter was 1, now becomes 0)
                    next_accum = 10'b0;
                    valid_out = 1'b1;
                end
                next_accum = next_accum + data_in;
                next_counter = ~counter;
            end
        endcase
    end
end

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        counter <= 1'b0;
        accum <= 10'b0;
    end else begin
        state <= next_state;
        counter <= next_counter;
        accum <= next_accum;
    end
end

endmodule