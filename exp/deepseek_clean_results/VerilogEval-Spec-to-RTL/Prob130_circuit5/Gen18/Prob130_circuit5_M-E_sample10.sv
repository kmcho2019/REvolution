module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Parallel case matching
wire case0 = (c == 4'd0);
wire case1 = (c == 4'd1);
wire case2 = (c == 4'd2);
wire case3 = (c == 4'd3);

// Priority encoder with case priorities
wire [3:0] selected_output = 
    case0 ? b :
    case1 ? e :
    case2 ? a :
    case3 ? d :
    4'b1111;  // default to 'f'

assign q = selected_output;

endmodule