module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output reg  w,
    output reg  x,
    output reg  y,
    output reg  z
);

    reg [3:0] out_vec;

    always @* begin
        out_vec[3] = a; // w
        out_vec[2] = b; // x
        out_vec[1] = b; // y
        out_vec[0] = c; // z
    end

    always @* begin
        w = out_vec[3];
        x = out_vec[2];
        y = out_vec[1];
        z = out_vec[0];
    end

endmodule