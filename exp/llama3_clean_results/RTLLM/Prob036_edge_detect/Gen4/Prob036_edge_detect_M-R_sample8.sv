module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output        rise,     // Output signal indicating a rising edge
    output        down      // Output signal indicating a falling edge
);

// Define the states for the state machine
enum logic [0:0] {IDLE, EDGE_DETECTED} state, next_state;

// Register to store the previous state of 'a'
reg prev_a;

// Initialize the previous state of 'a' to 0
initial begin
    prev_a = 1'b0;
end

// Sequential logic to store the previous state of 'a'
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the module
        prev_a <= 1'b0;
        state <= IDLE;
    end else begin
        // Store the current state of 'a' in the previous state register
        prev_a <= a;
        state <= next_state;
    end
end

// Combinational logic for edge detection
always @(*) begin
    case (state)
        IDLE: begin
            if (a == 1'b1 && prev_a == 1'b0) begin
                next_state = EDGE_DETECTED;
                rise = 1'b1;
                down = 1'b0;
            end else if (a == 1'b0 && prev_a == 1'b1) begin
                next_state = EDGE_DETECTED;
                rise = 1'b0;
                down = 1'b1;
            end else begin
                next_state = IDLE;
                rise = 1'b0;
                down = 1'b0;
            end
        end
        EDGE_DETECTED: begin
            next_state = IDLE;
            rise = 1'b0;
            down = 1'b0;
        end
        default: begin
            next_state = IDLE;
            rise = 1'b0;
            down = 1'b0;
        end
    endcase
end

endmodule