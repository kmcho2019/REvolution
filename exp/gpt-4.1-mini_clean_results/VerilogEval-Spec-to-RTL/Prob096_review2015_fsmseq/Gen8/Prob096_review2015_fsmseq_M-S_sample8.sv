module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // State encoding (minimal states to track sequence 1101)
    localparam S0 = 2'd0; // no match
    localparam S1 = 2'd1; // matched '1'
    localparam S2 = 2'd2; // matched '11' or after partial match
    localparam S3 = 2'd3; // matched '110'

    reg [1:0] state, next_state;
    reg detected;

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S1 : S0; // if data=1, restart partial match
            default: next_state = S0;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            detected <= 1'b0;
        end else begin
            state <= next_state;
            // Detect sequence 1101 when in S3 and data=1 (sequence complete)
            if (state == S3 && data)
                detected <= 1'b1;
        end
    end

    // Output is sticky after detection
    assign start_shifting = detected;

endmodule