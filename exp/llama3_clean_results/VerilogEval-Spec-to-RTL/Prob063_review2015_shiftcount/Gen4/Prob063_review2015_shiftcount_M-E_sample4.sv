module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

// Define states for the state machine
enum logic [1:0] {
    IDLE,
    SHIFT,
    COUNT
} state, next_state;

// Register to hold the current value
reg [3:0] counter;

// Register to hold the shifted value
reg [3:0] shift_reg;

// Initialize the registers and state
initial begin
    state = IDLE;
    counter = 4'b0000;
    shift_reg = 4'b0000;
end

// State machine logic
always @(posedge clk) begin
    state <= next_state;
    case (state)
        IDLE: begin
            if (shift_ena) begin
                next_state <= SHIFT;
                // Initialize shift register with the new data
                shift_reg <= {data, 4'b0000};
            end else if (count_ena) begin
                next_state <= COUNT;
            end else begin
                next_state <= IDLE;
            end
        end
        SHIFT: begin
            // Shift the data into the shift register
            shift_reg <= {shift_reg[2:0], data};
            if (shift_reg[3] == 1'b1) begin
                // Update the counter register with the shifted value
                counter <= shift_reg;
                next_state <= IDLE;
            end else begin
                next_state <= SHIFT;
            end
        end
        COUNT: begin
            // Decrement the counter
            if (counter == 4'b0000) begin
                counter <= 4'b1111; // Wrap around to maximum value
            end else begin
                counter <= counter - 1;
            end
            next_state <= IDLE;
        end
    endcase
end

// Assign the value of counter to output q
assign q = counter;

endmodule