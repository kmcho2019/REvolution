module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [2:0] state; // 3-bit state register

// State definition
localparam S0 = 3'b000; // Initial state
localparam S1 = 3'b001; // '1' detected
localparam S2 = 3'b010; // '11' detected
localparam S3 = 3'b011; // '110' detected
localparam S4 = 3'b100; // Sequence detected, start shifting

// Combinational logic for next state
reg [2:0] next_state;
always @(*) begin
    case (state)
        S0: next_state = data ? S1 : S0;
        S1: next_state = data ? S2 : S0;
        S2: next_state = ~data ? S3 : S2;
        S3: next_state = data ? S4 : S0;
        S4: next_state = S4; // Remain in this state once reached
        default: next_state = S0;
    endcase
end

// Synchronous reset and state update
always @(posedge clk) begin
    if (reset) begin
        state <= S0; // Reset state
        start_shifting <= 0; // Reset start_shifting
    end else begin
        state <= next_state;
        if (state == S4) begin
            start_shifting <= 1; // Set start_shifting when sequence detected
        end else if (next_state != S4 && state != S4) begin
            start_shifting <= 0; // Reset start_shifting if not in S4
        end
    end
end

endmodule