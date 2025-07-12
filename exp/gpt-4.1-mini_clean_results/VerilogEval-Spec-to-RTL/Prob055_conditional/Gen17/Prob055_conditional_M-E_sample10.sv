module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);
    always @(*) begin
        reg [7:0] temp_min;
        temp_min = a;
        if (b < temp_min) temp_min = b;
        if (c < temp_min) temp_min = c;
        if (d < temp_min) temp_min = d;
        min = temp_min;
    end
endmodule