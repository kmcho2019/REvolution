module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// State encoding
localparam S4 = 3'd4;
localparam S5 = 3'd5;
localparam S6 = 3'd6;
localparam S0 = 3'd0;
localparam S1 = 3'd1;

reg [2:0] state, next_state;

// State transition logic
always @(*) begin
    if (a) begin
        next_state = state;  // hold when a is high
    end else begin
        case (state)
            S4: next_state = S5;
            S5: next_state = S6;
            S6: next_state = S0;
            S0: next_state = S1;
            S1: next_state = S0;  // This creates a repeating pattern
            default: next_state = S4;
        endcase
    end
end

// State register with initial state
initial begin
    state = S4;
end

always @(posedge clk) begin
    state <= next_state;
end

// Output logic
always @(*) begin
    q = state;
end

endmodule