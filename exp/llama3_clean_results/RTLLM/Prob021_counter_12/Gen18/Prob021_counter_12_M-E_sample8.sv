module counter_12 #(
    parameter WIDTH = 4,  // Width of the counter
    parameter MAX_COUNT = 11  // Maximum count value
)(
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [WIDTH-1:0] out  // Output representing the current count value
);

// Define the states of the finite state machine
enum logic [1:0] {
    IDLE,
    COUNTING
} state, next_state;

// Internal register to hold the current count
logic [WIDTH-1:0] current_count;

// Combinational logic to determine the next state
always_comb begin
    case(state)
        IDLE: begin
            if (valid_count) begin
                next_state = COUNTING;
            end else begin
                next_state = IDLE;
            end
        end
        COUNTING: begin
            if (current_count == MAX_COUNT) begin
                next_state = IDLE;
            end else if (!valid_count) begin
                next_state = IDLE;
            end else begin
                next_state = COUNTING;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Sequential logic to update the state and count
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        current_count <= '0;
    end else begin
        state <= next_state;
        case(state)
            COUNTING: begin
                if (next_state == COUNTING) begin
                    current_count <= current_count + 1;
                end else begin
                    current_count <= '0;
                end
            end
            default: current_count <= '0;
        endcase
    end
end

// Continuous assignment to output the current count
assign out = current_count;

endmodule