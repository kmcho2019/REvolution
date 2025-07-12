module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

// Enum for states
enum logic [1:0] {IDLE, COUNTING} state, next_state;

// Current count value
logic [3:0] count;

// Sequential logic for state machine and counter
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        count <= 4'b0000;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (valid_count) begin
                    count <= 4'b0000;
                end
            end
            COUNTING: begin
                if (count == 4'd11) begin
                    count <= 4'b0000;
                end else begin
                    count <= count + 1;
                end
            end
            default: count <= count;
        endcase
    end
end

// Combinational logic for next state and output
always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (valid_count) begin
                next_state = COUNTING;
            end
        end
        COUNTING: begin
            if (!valid_count) begin
                next_state = IDLE;
            end
        end
        default: next_state = state;
    endcase
    out = count;
end

endmodule