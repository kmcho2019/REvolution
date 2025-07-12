module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// State encoding (binary)
localparam S0 = 3'd0; // no match
localparam S1 = 3'd1; // matched '1'
localparam S2 = 3'd2; // matched "11"
localparam S3 = 3'd3; // matched "110"

// State register
reg [2:0] state, next_state;

// Sequential logic: state update and latch output start_shifting on detection
always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        start_shifting <= 1'b0;
    end else begin
        state <= next_state;
        // latch start_shifting once detected
        if (start_shifting)
            start_shifting <= 1'b1;
        else
            start_shifting <= (state == S3) && data; // Mealy output: detected on input '1' after S3
    end
end

// Next state logic based on current state and input
always @(*) begin
    case (state)
        S0: next_state = data ? S1 : S0;
        S1: next_state = data ? S2 : S0;
        S2: next_state = data ? S2 : S3;
        S3: next_state = data ? S1 : S0;
        default: next_state = S0;
    endcase
end

endmodule