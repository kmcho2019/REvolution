module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding as localparams
    localparam S0 = 3'd0; // no match
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched '11'
    localparam S3 = 3'd3; // matched '110'

    reg [2:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output logic register: latch start_shifting when sequence detected (on S3 and data=1)
    always @(posedge clk) begin
        if (reset)
            start_shifting <= 1'b0;
        else if (state == S3 && data == 1'b1)
            start_shifting <= 1'b1;
        else
            start_shifting <= start_shifting; // hold asserted once set
    end

endmodule