module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);
    // Pack inputs into a 4-element array for clarity (index 0=b,1=e,2=a,3=d)
    wire [3:0] inputs_array [0:3];
    assign inputs_array[0] = b;
    assign inputs_array[1] = e;
    assign inputs_array[2] = a;
    assign inputs_array[3] = d;

    always @(*) begin
        if (c < 4)
            q = inputs_array[c];
        else
            q = 4'hF;
    end
endmodule