module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output Z
);

    reg [7:0] Q;

    always @(posedge clk) begin
        if (enable)
            Q <= {S, Q[7:1]}; // shift in S at MSB (Q[7]), shift right
    end

    // Select output Z using ABC as address into Q
    // {A,B,C} form a 3-bit vector to index Q
    assign Z = Q[{A, B, C}];

endmodule