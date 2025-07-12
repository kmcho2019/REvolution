module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

// One-hot state encoding
localparam S0 = 5'b00001; // no match
localparam S1 = 5'b00010; // matched '1'
localparam S2 = 5'b00100; // matched "11"
localparam S3 = 5'b01000; // matched "110"
localparam S4 = 5'b10000; // matched "1101" (final)

// State register
reg [4:0] state, next_state;

// Synchronous state update
always @(posedge clk) begin
    if (reset)
        state <= S0;
    else
        state <= next_state;
end

// Next state logic (combinational)
always @(*) begin
    case (state)
        S0: next_state = data ? S1 : S0;
        S1: next_state = data ? S2 : S0;
        S2: next_state = data ? S2 : S3;
        S3: next_state = data ? S4 : S0;
        S4: next_state = S4;
        default: next_state = S0;
    endcase
end

// Output logic: start_shifting is high if in the final detected state
assign start_shifting = (state == S4);

endmodule