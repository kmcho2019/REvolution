module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

    // Define a 5-element array for selection: b(0), e(1), a(2), d(3), 4'hF(4)
    wire [3:0] data_array [0:4];
    assign data_array[0] = b;
    assign data_array[1] = e;
    assign data_array[2] = a;
    assign data_array[3] = d;
    assign data_array[4] = 4'hF;

    always @(*) begin
        if (c < 5)
            q = data_array[c];
        else
            q = 4'hF;
    end

endmodule