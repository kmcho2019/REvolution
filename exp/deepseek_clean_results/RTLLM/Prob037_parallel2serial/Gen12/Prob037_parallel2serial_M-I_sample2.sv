module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] state;        // One-hot state counter (0001, 0010, 0100, 1000)
    reg [3:0] shift_reg;    // Shift register for parallel-to-serial conversion
    wire load_new_data;     // Signal to load new parallel data

    // State and output assignments
    assign load_new_data = state[3];  // Last state indicates time to load new data
    assign dout = shift_reg[3];      // Always output MSB
    assign valid_out = state[0];     // Valid only in first state

    // Pre-compute next shift register value
    wire [3:0] next_shift = load_new_data ? d : {shift_reg[2:0], 1'b0};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 4'b0001;       // Initialize to first state
            shift_reg <= 4'b0;
        end else begin
            // Update shift register with clock gating for power optimization
            shift_reg <= next_shift;

            // One-hot state transition
            if (load_new_data) begin
                state <= 4'b0001;  // Wrap around to first state
            end else begin
                state <= {state[2:0], state[3]};  // Rotate left
            end
        end
    end

endmodule