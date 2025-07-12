module barrel_shifter #(
    parameter WIDTH = 8
)(
    input [WIDTH-1:0] in,
    input [2:0] ctrl,
    output [WIDTH-1:0] out
);
    // Generate all possible shift amounts in parallel
    wire [WIDTH-1:0] shift1 = {in[WIDTH-2:0], in[WIDTH-1]};  // rotate left by 1
    wire [WIDTH-1:0] shift2 = {in[WIDTH-3:0], in[WIDTH-1:WIDTH-2]};  // rotate left by 2
    wire [WIDTH-1:0] shift4 = {in[WIDTH-5:0], in[WIDTH-1:WIDTH-4]};  // rotate left by 4
    
    // Combine shifts based on control signals
    assign out = (ctrl[0] ? shift1 : in) |
                 (ctrl[1] ? shift2 : 0) |
                 (ctrl[2] ? shift4 : 0);
endmodule