module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Define the states for the FSM
enum logic [2:0] {
    IDLE,
    SHIFT_IN,
    COUNT_ONES,
    ACCUMULATE,
    OUTPUT
} state, next_state;

// Define the shift register for the input vector
reg [7:0] shift_reg [31:0];

// Define the counter for the '1's in each chunk
reg [7:0] count_reg;

// Define the accumulator for the total count
reg [7:0] total_count;

// FSM logic
always @(posedge clk) begin
    case (state)
        IDLE: begin
            // Initialize the shift register and counters
            for (int i = 0; i < 32; i++) begin
                shift_reg[i] <= 8'b0;
            end
            count_reg <= 8'b0;
            total_count <= 8'b0;
            next_state <= SHIFT_IN;
        end
        SHIFT_IN: begin
            // Shift the input vector into the shift register
            for (int i = 0; i < 31; i++) begin
                shift_reg[i] <= shift_reg[i + 1];
            end
            shift_reg[31] <= in[254:247];
            in <= in << 8;
            next_state <= COUNT_ONES;
        end
        COUNT_ONES: begin
            // Count the '1's in the current chunk
            count_reg <= $countones(shift_reg[0]);
            next_state <= ACCUMULATE;
        end
        ACCUMULATE: begin
            // Accumulate the count
            total_count <= total_count + count_reg;
            next_state <= SHIFT_IN;
        end
        OUTPUT: begin
            // Output the total count
            out <= total_count;
            next_state <= IDLE;
        end
        default: next_state <= IDLE;
    endcase
    state <= next_state;
end

// Clock gating logic
reg clk_enable;
always @(posedge clk) begin
    if (state == IDLE) begin
        clk_enable <= 1'b0;
    end else begin
        clk_enable <= 1'b1;
    end
end

endmodule