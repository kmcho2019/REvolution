module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// One-hot state encoding
localparam S4 = 7'b0001000;
localparam S5 = 7'b0010000;
localparam S6 = 7'b0100000;
localparam S0 = 7'b1000000;
localparam S1 = 7'b0000001;

reg [6:0] state, next_state;

// State transition logic
always @(*) begin
    if (a) begin
        next_state = S4;  // Reset to state 4 when a=1
    end else begin
        case (1'b1)  // Synthesis-friendly case statement for one-hot
            state[S4]: next_state = S5;
            state[S5]: next_state = S6;
            state[S6]: next_state = S0;
            state[S0]: next_state = S1;
            state[S1]: next_state = S4;
            default: next_state = S4;
        endcase
    end
end

// State register
always @(posedge clk) begin
    state <= next_state;
end

// Output decoder
always @(*) begin
    case (1'b1)  // One-hot to binary conversion
        state[S4]: q = 3'd4;
        state[S5]: q = 3'd5;
        state[S6]: q = 3'd6;
        state[S0]: q = 3'd0;
        state[S1]: q = 3'd1;
        default: q = 3'd4;
    endcase
end

// Initialize to state 4
initial begin
    state = S4;
    q = 3'd4;
end

endmodule