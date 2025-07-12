module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding
    localparam S0 = 3'b000; // no match
    localparam S1 = 3'b001; // matched '1'
    localparam S2 = 3'b010; // matched '11'
    localparam S3 = 3'b011; // matched '110'

    reg [2:0] state, next_state;
    wire detect_seq;

    // Mealy next-state and output detection logic
    always @(*) begin
        case(state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S1 : S0; // after detecting '110', next depends on input
            default: next_state = S0;
        endcase
    end

    // Detect sequence 1101 on current input and state (Mealy output)
    // The sequence ends when input=1 at S3 (which corresponds to last bit '1')
    assign detect_seq = (state == S3) && (data == 1'b1);

    // Sequential logic: state update and sticky output latch
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (detect_seq)
                start_shifting <= 1'b1; // latch set when sequence detected
        end
    end

endmodule