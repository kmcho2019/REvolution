module TopModule #(parameter WIDTH = 100) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

generate
    if (WIDTH <= 1) begin
        assign out = in;
    end
    else if (WIDTH == 2) begin
        assign out = {in[0], in[1]};  // Base case: swap 2 bits
    end
    else begin
        // Recursively reverse upper and lower halves, then concatenate swapped
        wire [WIDTH/2-1:0] upper_rev, lower_rev;
        TopModule #(.WIDTH(WIDTH/2)) upper (.in(in[WIDTH-1:WIDTH/2]), .out(lower_rev));
        TopModule #(.WIDTH(WIDTH-WIDTH/2)) lower (.in(in[WIDTH/2-1:0]), .out(upper_rev));
        assign out = {lower_rev, upper_rev};
    end
endgenerate

endmodule