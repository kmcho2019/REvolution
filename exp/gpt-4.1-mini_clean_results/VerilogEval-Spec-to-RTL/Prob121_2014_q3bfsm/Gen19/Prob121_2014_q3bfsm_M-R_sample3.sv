module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

    // One-hot encoded states
    localparam S0 = 5'b00001,
               S1 = 5'b00010,
               S2 = 5'b00100,
               S3 = 5'b01000,
               S4 = 5'b10000;

    reg [4:0] state, next_state;

    // Next state logic as combinational assignments
    wire s0 = state[0], s1 = state[1], s2 = state[2], s3 = state[3], s4 = state[4];

    always @(*) begin
        next_state = 5'b0;
        case (1'b1) // one-hot style case to simplify logic
            s0: next_state = x ? S1 : S0;
            s1: next_state = x ? S4 : S1;
            s2: next_state = x ? S1 : S2;
            s3: next_state = x ? S2 : S1;
            s4: next_state = x ? S4 : S3;
            default: next_state = S0;
        endcase
    end

    // State register update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output z is asserted when state is S3 or S4
    assign z = s3 | s4;

endmodule