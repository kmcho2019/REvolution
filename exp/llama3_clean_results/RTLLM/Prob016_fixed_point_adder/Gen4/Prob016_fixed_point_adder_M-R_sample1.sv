module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

// Separate modules for addition, subtraction, and overflow handling
wire [N:0] add_result;
wire [N:0] sub_result;
wire [N-1:0] result;

// Perform addition
assign add_result = (a[N-1] == 1'b0)? {1'b0, a} + {1'b0, b} : {1'b1, a} + {1'b1, b};

// Perform subtraction
assign sub_result = (a[N-1] == 1'b0)? {1'b0, a} - {1'b0, b} : {1'b1, a} - {1'b1, b};

// Determine result based on signs of a and b
assign result = (a[N-1] == b[N-1])? add_result[N-1:0] : 
                ((a[N-1] == 1'b0 && (a > b)) || (a[N-1] == 1'b1 && (b > a)))? 
                sub_result[N-1:0] : (a[N-1] == 1'b0)? sub_result[N-1:0] : ~sub_result[N-1:0] + 1;

// Handle overflow by saturating the result
assign c = (result[N-1] == 1'b1 && result[N-2:0] == {N-1{1'b1}})? {N{1'b1}} : 
           (result[N-1] == 1'b0 && result[N-2:0] == {N-1{1'b0}})? {N{1'b0}} : result;

endmodule