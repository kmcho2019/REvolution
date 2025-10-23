module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] state;        // One-hot state (0001, 0010, 0100, 1000)
    reg [3:0] shift_reg;    // Shift register
    wire shift_en;          // Shift enable (gated clock)

    // One-hot encoding assignments
    assign shift_en = ~state[3];  // Shift enabled except during load
    assign dout = shift_reg[3];
    assign valid_out = state[0];  // Valid only in first state

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 4'b0001;    // Initialize to first state
            shift_reg <= 4'b0;
        end else begin
            // State transition (circular one-hot shift)
            state <= {state[2:0], state[3]};

            // Shift register update with clock gating
            if (state[3]) begin
                // Load new data
                shift_reg <= d;
            end else if (shift_en) begin
                // Optimized shift operation
                shift_reg <= {shift_reg[2:0], 1'b0};
            end
        end
    end

endmodule