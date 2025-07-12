module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

    // One-hot state encoding: only one bit high to represent each state
    // States: S0=00001, S1=00010, S2=00100, S3=01000, S4=10000
    localparam S0 = 5'b00001;
    localparam S1 = 5'b00010;
    localparam S2 = 5'b00100;
    localparam S3 = 5'b01000;
    localparam S4 = 5'b10000;

    reg [4:0] state, next_state;

    // Synchronous reset and state register update
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state combinational logic based on one-hot current state and input x
    always @(*) begin
        case (1'b1) // priority encoder over one-hot state bits
            state[0]: next_state = x ? S1 : S0;       // S0
            state[1]: next_state = x ? S4 : S1;       // S1
            state[2]: next_state = x ? S1 : S2;       // S2
            state[3]: next_state = x ? S2 : S1;       // S3
            state[4]: next_state = x ? S4 : S3;       // S4
            default:  next_state = S0;                 // safe fallback
        endcase
    end

    // Output is high when in states S3 or S4 (bits 3 or 4 are high)
    assign z = state[3] | state[4];

endmodule