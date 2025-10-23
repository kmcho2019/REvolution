module LFSR (
    input wire clk,
    input wire rst,
    output wire [3:0] out
);

reg [3:0] state;
reg poly_select;  // Selects between two feedback polynomials

// Scrambled output permutation: [2,0,3,1]
assign out = {state[2], state[0], state[3], state[1]};

// Rising edge feedback: out[3] XOR out[2] (as specified)
wire feedback_rise = state[3] ^ state[2];

// Falling edge feedback: out[3] XOR out[1] (additional polynomial)
wire feedback_fall = state[3] ^ state[1];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 4'b0001;  // Initialize to non-zero state
        poly_select <= 1'b0;
    end else begin
        // Check for all-zero state (should never occur)
        if (state == 4'b0000) begin
            state <= 4'b0001;  // Force recovery
        end else begin
            // Rising edge update with polynomial 0
            state <= {state[2:0], feedback_rise};
        end
        poly_select <= ~poly_select;  // Toggle polynomial select
    end
end

always @(negedge clk) begin
    if (~rst) begin
        if (state != 4'b0000) begin  // Skip if in recovery
            // Falling edge update with polynomial 1
            state <= {state[2:0], feedback_fall};
        end
    end
end

endmodule