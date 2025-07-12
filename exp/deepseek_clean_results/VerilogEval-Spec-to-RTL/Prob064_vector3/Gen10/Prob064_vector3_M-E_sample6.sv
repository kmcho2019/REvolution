module TopModule (
    input [4:0] a, b, c, d, e, f,
    output reg [7:0] w, x, y, z
);

    always @(*) begin
        // Fill w with a and part of b
        w = {a, b[4:2]};
        
        // Fill x with remaining b and part of c
        x = {b[1:0], c, d[4:4]};
        
        // Fill y with remaining d and part of e
        y = {d[3:0], e[4:1]};
        
        // Fill z with remaining e and all of f plus padding
        z = {e[0], f, 2'b11};
    end

endmodule