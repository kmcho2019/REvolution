module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

// State encoding (binary)
localparam [2:0]
    S0 = 3'd0, // no match
    S1 = 3'd1, // matched '1'
    S2 = 3'd2, // matched "11"
    S3 = 3'd3; // matched "110"

// State register
reg [2:0] state, next_state;
// Registered output flag indicating sequence detected
reg detected;

// Next state combinational logic
always @(*) begin
    case (state)
        S0: next_state = data ? S1 : S0;
        S1: next_state = data ? S2 : S0;
        S2: next_state = data ? S2 : S3;
        S3: next_state = data ? S1 : S0; // After "110" input=1 leads to S1 (to detect overlapping)
        default: next_state = S0;
    endcase
end

// Sequential logic for state update and detected flag
always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        detected <= 1'b0;
    end else begin
        state <= next_state;
        // Set detected high when sequence "1101" found: S3 + data=1 -> start_shifting
        if (detected == 1'b0 && state == S3 && data == 1'b1)
            detected <= 1'b1;
        else
            detected <= detected; // latch forever after detection
    end
end

// Output driven by detected flag
assign start_shifting = detected;

endmodule