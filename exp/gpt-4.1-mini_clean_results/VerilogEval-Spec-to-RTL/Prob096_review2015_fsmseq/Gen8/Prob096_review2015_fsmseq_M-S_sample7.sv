module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // Minimal FSM states to detect 1101
    localparam S0 = 2'd0; // no match yet
    localparam S1 = 2'd1; // matched '1'
    localparam S2 = 2'd2; // matched '11' or partial overlap
    localparam S3 = 2'd3; // matched '110'
    // S4 (final state) merged into S3 to minimize states by holding start_shifting in S3 when sequence detected

    reg [1:0] state, next_state;
    reg detected;

    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3; // if data=0 after '11', matched '110'
            S3: next_state = S3; // sticky final detected state
            default: next_state = S0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            detected <= 1'b0;
        end else begin
            state <= next_state;
            // set detected when reaching S3 with input data = 1
            if (state == S3)
                detected <= 1'b1;
        end
    end

    assign start_shifting = detected;

endmodule