module TopModule (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Output w: [7:5] = a[4:2], [4:0] = {a[1:0], b[4:2]}
    assign w = {a[4:0], b[4:2]};
    
    // Output x: [7:5] = b[1:0], c[4:2], [4:0] = {c[1:0], d[4]}
    assign x = {b[1:0], c[4:0], d[4]};
    
    // Output y: [7:4] = d[3:0], [3:0] = e[4:1]
    assign y = {d[3:0], e[4:1]};
    
    // Output z: [7:6] = e[0], f[4:3], [5:0] = {f[2:0], 2'b11}
    assign z = {e[0], f[4:0], 2'b11};

endmodule