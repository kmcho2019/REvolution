module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

    // Define a small ROM with 5 entries corresponding to possible q outputs
    wire [3:0] lut [0:4];

    assign lut[0] = b;
    assign lut[1] = e;
    assign lut[2] = a;
    assign lut[3] = d;
    assign lut[4] = 4'hF;

    always @(*) begin
        // Cap c at 4 to prevent out-of-bound indexing
        if (c < 5)
            q = lut[c];
        else
            q = lut[4]; // 4'hF default
    end

endmodule