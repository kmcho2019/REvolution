module edge_detect #
(
    parameter WIDTH = 1
)
(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input  [WIDTH-1:0] a,    // Input signal
    output [WIDTH-1:0] rise, // Output signal indicating a rising edge
    output [WIDTH-1:0] down  // Output signal indicating a falling edge
);

// Define the states of the FSM
enum logic [1:0] {IDLE, EDGE_DETECTED} state, next_state;

// Register to store the previous state of 'a'
reg [WIDTH-1:0] prev_a;

// Initialize the previous state of 'a' to 0
initial begin
    prev_a = {WIDTH{1'b0}};
end

// Sequential logic to store the previous state of 'a' and the current state of the FSM
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the module
        prev_a <= {WIDTH{1'b0}};
        state <= IDLE;
    end else begin
        // Store the current state of 'a' in the previous state register
        prev_a <= a;
        state <= next_state;
    end
end

// Combinational logic to detect the edges and determine the next state of the FSM
always @(*) begin
    next_state = state;
    rise = {WIDTH{1'b0}};
    down = {WIDTH{1'b0}};
    
    case (state)
        IDLE: begin
            if (a != prev_a) begin
                next_state = EDGE_DETECTED;
                if (a == {WIDTH{1'b1}}) begin
                    rise = {WIDTH{1'b1}};
                end else begin
                    down = {WIDTH{1'b1}};
                end
            end
        end
        EDGE_DETECTED: begin
            next_state = IDLE;
        end
    endcase
end

endmodule