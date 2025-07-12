module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding: 2 bits
    // S0: no match
    // S1: matched '1'
    // S2: matched '11'
    // S3: matched '110'
    localparam S0 = 2'd0;
    localparam S1 = 2'd1;
    localparam S2 = 2'd2;
    localparam S3 = 2'd3;

    reg [1:0] state, next_state;
    wire detected;

    // Mealy output: sequence "1101" detected when current state S3 and input data=1
    assign detected = (state == S3) && (data == 1'b1);

    // Next-state logic (combinational)
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
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Once detected, latch start_shifting high forever until reset
            if (detected)
                start_shifting <= 1'b1;
        end
    end

endmodule