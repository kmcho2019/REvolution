module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

// Define the states for the finite state machine
enum logic [1:0] {
    IDLE,
    COUNTING
} state, next_state;

// Register to hold the current state
logic [3:0] count;

// Combinational logic to determine the next state
always_comb begin
    case (state)
        IDLE: begin
            if (valid_count) begin
                next_state = COUNTING;
            end else begin
                next_state = IDLE;
            end
        end
        COUNTING: begin
            if (!valid_count) begin
                next_state = IDLE;
            end else begin
                next_state = COUNTING;
            end
        end
    endcase
end

// Sequential logic to update the state and counter
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        count <= 4'b0000;
    end else begin
        state <= next_state;
        case (state)
            COUNTING: begin
                if (count == 4'd11) begin
                    count <= 4'b0000;
                end else begin
                    count <= count + 1;
                end
            end
            default: begin
                count <= 4'b0000;
            end
        endcase
    end
end

// Assign the output
assign out = count;

endmodule