module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    localparam [2:0]
        S0 = 3'b000, // no match
        S1 = 3'b001, // matched '1'
        S2 = 3'b010, // matched "11"
        S3 = 3'b011, // matched "110"
        S4 = 3'b100; // matched "1101" (final detected)

    reg [2:0] state;
    wire [2:0] next_state;

    // Combinational next_state logic using nested ternary operators
    assign next_state = (state == S0) ? (data ? S1 : S0) :
                        (state == S1) ? (data ? S2 : S0) :
                        (state == S2) ? (data ? S2 : S3) :
                        (state == S3) ? (data ? S4 : S0) :
                        S4;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output asserted once sequence detected
    assign start_shifting = (state == S4);

endmodule