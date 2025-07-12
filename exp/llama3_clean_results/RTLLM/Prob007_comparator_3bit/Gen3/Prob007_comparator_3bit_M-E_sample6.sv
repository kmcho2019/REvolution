module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*) begin
    case ({A, B})
        // A > B
        8'h0: {A_greater, A_equal, A_less} = 3'b100;
        8'h1: {A_greater, A_equal, A_less} = 3'b100;
        8'h2: {A_greater, A_equal, A_less} = 3'b100;
        8'h3: {A_greater, A_equal, A_less} = 3'b100;
        8'h4: {A_greater, A_equal, A_less} = 3'b100;
        8'h5: {A_greater, A_equal, A_less} = 3'b100;
        8'h6: {A_greater, A_equal, A_less} = 3'b100;
        8'h7: {A_greater, A_equal, A_less} = 3'b100;
        // A == B
        8'h8: {A_greater, A_equal, A_less} = 3'b010;
        8'h9: {A_greater, A_equal, A_less} = 3'b010;
        8'ha: {A_greater, A_equal, A_less} = 3'b010;
        8'hb: {A_greater, A_equal, A_less} = 3'b010;
        8'hc: {A_greater, A_equal, A_less} = 3'b010;
        8'hd: {A_greater, A_equal, A_less} = 3'b010;
        8'he: {A_greater, A_equal, A_less} = 3'b010;
        8'hf: {A_greater, A_equal, A_less} = 3'b010;
        // A < B
        default: {A_greater, A_equal, A_less} = 3'b001;
    endcase
end

endmodule