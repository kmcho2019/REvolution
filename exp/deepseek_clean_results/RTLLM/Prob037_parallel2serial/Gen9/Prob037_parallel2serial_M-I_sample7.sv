module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] shift_reg;
    reg [3:0] state;  // One-hot state: 0001, 0010, 0100, 1000

    // Enable signal to reduce power when idle
    wire processing = |shift_reg || (state != 4'b0001);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            state <= 4'b0001;  // Start in state 0 (one-hot)
        end else if (processing) begin
            // Rotate state one-hot counter
            state <= {state[2:0], state[3]};
            
            // Load new data when completing a cycle
            if (state[3]) begin
                shift_reg <= d;
            end else begin
                // Shift left when not in load state
                shift_reg <= {shift_reg[2:0], 1'b0};
            end
        end
    end

    // Output assignments
    assign valid_out = state[0];  // Valid when in first state
    assign dout = shift_reg[3];   // Always output MSB

endmodule