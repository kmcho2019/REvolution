module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// State encoding (binary)
localparam [2:0]
    S0 = 3'd0, // no match
    S1 = 3'd1, // matched '1'
    S2 = 3'd2, // matched "11"
    S3 = 3'd3, // matched "110"
    S4 = 3'd4; // matched "1101" detected

reg [2:0] state, next_state;

// Next state logic
always @(*) begin
    case(state)
        S0: next_state = data ? S1 : S0;
        S1: next_state = data ? S2 : S0;
        S2: next_state = data ? S2 : S3;
        S3: next_state = data ? S4 : S0;
        S4: next_state = S4;
        default: next_state = S0;
    endcase
end

// Sequential logic for state and output
always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        start_shifting <= 1'b0;
    end else begin
        state <= next_state;
        if (state == S4)
            start_shifting <= 1'b1;
        else
            start_shifting <= start_shifting; // hold once set
    end
end

endmodule