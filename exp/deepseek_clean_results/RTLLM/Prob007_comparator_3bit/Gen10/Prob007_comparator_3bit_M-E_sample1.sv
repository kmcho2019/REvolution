module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

// State encoding
localparam EQUAL = 2'b00;
localparam GREATER = 2'b01;
localparam LESS = 2'b10;

reg [1:0] state;

always @* begin
    state = EQUAL; // Start assuming equal
    
    // MSB first comparison
    if (A[2] != B[2]) begin
        state = A[2] ? GREATER : LESS;
    end
    else if (A[1] != B[1]) begin
        state = A[1] ? GREATER : LESS;
    end
    else if (A[0] != B[0]) begin
        state = A[0] ? GREATER : LESS;
    end

    // Output assignment
    A_greater = (state == GREATER);
    A_equal = (state == EQUAL);
    A_less = (state == LESS);
end

endmodule