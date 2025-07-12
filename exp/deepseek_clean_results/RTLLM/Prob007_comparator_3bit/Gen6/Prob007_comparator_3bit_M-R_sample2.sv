module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

// Local parameters for comparison states
localparam GREATER = 3'b100;
localparam EQUAL   = 3'b010;
localparam LESS    = 3'b001;

// Single always block for all comparisons
always @(*) begin
    // Default assignments
    {A_greater, A_equal, A_less} = 3'b000;
    
    // Comparison logic
    case (1'b1)
        (A > B):  {A_greater, A_equal, A_less} = GREATER;
        (A == B): {A_greater, A_equal, A_less} = EQUAL;
        (A < B):  {A_greater, A_equal, A_less} = LESS;
    endcase
end

// Property: Only one output can be high at any time
// assert property (@(posedge clk) $onehot0({A_greater, A_equal, A_less}));

endmodule