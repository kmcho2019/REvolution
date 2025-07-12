module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] shift_reg;
    reg [3:0] state;  // One-hot state: 0001, 0010, 0100, 1000

    // State machine and shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            state <= 4'b0001;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            // State transition
            state <= {state[2:0], state[3]};

            // Shift register update only when needed
            if (state[3]) begin
                shift_reg <= d;  // Load new data
                valid_out <= 1'b1;
            end else begin
                shift_reg <= {shift_reg[2:0], 1'b0};  // Shift left
                valid_out <= 1'b0;
            end

            // Registered output
            dout <= shift_reg[3];
        end
    end

endmodule