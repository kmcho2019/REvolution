module TopModule(
    input        clk,
    input        reset,
    input        x,
    output       z
);

    // State encoding using localparams for clarity
    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4;

    reg [2:0] state;
    wire [2:0] next_state;

    // Combinational next state logic using continuous assignment and ternary operators
    assign next_state = (state == S0) ? (x ? S1 : S0) :
                        (state == S1) ? (x ? S4 : S1) :
                        (state == S2) ? (x ? S1 : S2) :
                        (state == S3) ? (x ? S2 : S1) :
                        (state == S4) ? (x ? S4 : S3) :
                        S0;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output logic as a combinational assignment
    assign z = (state == S3) || (state == S4);

endmodule