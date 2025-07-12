module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

    // One-hot state encoding
    localparam S0 = 5'b00001;
    localparam S1 = 5'b00010;
    localparam S2 = 5'b00100;
    localparam S3 = 5'b01000;
    localparam S4 = 5'b10000;

    reg [4:0] state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic combinational block
    always @(*) begin
        case (1'b1) // Using one-hot decoding
            state[0]: next_state = x ? S1 : S0; // S0
            state[1]: next_state = x ? S4 : S1; // S1
            state[2]: next_state = x ? S1 : S2; // S2
            state[3]: next_state = x ? S2 : S1; // S3
            state[4]: next_state = x ? S4 : S3; // S4
            default:  next_state = S0;
        endcase
    end

    // Output logic: z=1 for states S3 and S4 only
    assign z = state[3] | state[4];

endmodule