module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] shift_reg;
    reg [3:0] state;

    // State and shift register updates
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            state <= 4'b0001;  // Initial state (one-hot)
        end else begin
            if (state[0]) begin  // Load new data when state cycles
                shift_reg <= d;
            end else begin
                shift_reg <= {shift_reg[2:0], 1'b0};  // Rotate left
            end
            state <= {state[0], state[3:1]};  // Rotate state right
        end
    end

    // Output assignments
    assign valid_out = state[0];
    assign dout = shift_reg[3];  // Always output MSB

endmodule