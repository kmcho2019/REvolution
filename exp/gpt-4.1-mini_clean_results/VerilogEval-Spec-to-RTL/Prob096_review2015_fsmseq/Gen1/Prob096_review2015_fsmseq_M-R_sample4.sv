module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

// State encoding
localparam S0 = 3'd0; // no match
localparam S1 = 3'd1; // matched '1'
localparam S2 = 3'd2; // matched "11"
localparam S3 = 3'd3; // matched "110"
localparam S4 = 3'd4; // matched "1101" (final)

reg [2:0] current_state, next_state;
reg detected;

// State register
always @(posedge clk) begin
    if (reset) begin
        current_state <= S0;
        detected <= 1'b0;
    end else begin
        current_state <= next_state;
        // Latch detected once sequence is found
        if (next_state == S4)
            detected <= 1'b1;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        S0: next_state = data ? S1 : S0;
        S1: next_state = data ? S2 : S0;
        S2: next_state = (data == 1'b0) ? S3 : S2;
        S3: next_state = data ? S4 : S0;
        S4: next_state = S4; // Remain after detection
        default: next_state = S0;
    endcase
end

// Output driven by detected flag
assign start_shifting = detected;

endmodule