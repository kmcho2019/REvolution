module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding using 3-bit localparam for clarity and compactness
    localparam S0 = 3'b000; // no match
    localparam S1 = 3'b001; // matched '1'
    localparam S2 = 3'b010; // matched '11'
    localparam S3 = 3'b011; // matched '110'
    localparam S4 = 3'b100; // matched '1101' - sticky final state

    reg [2:0] state, next_state;

    // Combinational next-state logic
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S4 : S0;
            S4: next_state = S4;  // stay in final detected state
            default: next_state = S0;
        endcase
    end

    // Sequential state register and registered output with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Latch start_shifting once sequence detected (state S4)
            if (state == S4)
                start_shifting <= 1'b1;
        end
    end

endmodule