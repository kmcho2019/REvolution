module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding (binary)
    localparam S0 = 3'd0; // no match yet
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched '11'
    localparam S3 = 3'd3; // matched '110'
    localparam S4 = 3'd4; // matched '1101' (final detected state)

    reg [2:0] state, next_state;

    // Combinational next-state logic
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S4 : S0;
            S4: next_state = S4; // sticky final state
            default: next_state = S0;
        endcase
    end

    // Detect if sequence found at next clock (entering final state)
    wire seq_detected = (next_state == S4);

    // Sequential logic: state update and output register
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (seq_detected)
                start_shifting <= 1'b1; // latch output once sequence detected
            // else hold the previous value (sticky)
        end
    end

endmodule