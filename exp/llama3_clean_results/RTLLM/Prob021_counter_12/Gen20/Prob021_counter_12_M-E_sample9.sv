module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

// Define the states for the FSM
enum logic [1:0] {IDLE, COUNTING} state, next_state;

// Current count value
logic [3:0] count = 4'b0000;

// Sequential logic for the FSM
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        count <= 4'b0000;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (valid_count) begin
                    next_state <= COUNTING;
                    count <= 4'b0000;
                end else begin
                    next_state <= IDLE;
                end
            end
            COUNTING: begin
                if (!valid_count) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= COUNTING;
                    if (count == 4'd11) begin
                        count <= 4'b0000;
                    end else begin
                        count <= count + 1;
                    end
                end
            end
            default: next_state <= IDLE;
        endcase
    end
end

// Combinational logic for the output
always_comb begin
    case (state)
        IDLE: out = 4'b0000;
        COUNTING: out = count;
        default: out = 4'b0000;
    endcase
end

endmodule