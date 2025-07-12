module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);
    reg [3:0] out_vec;

    always @(*) begin
        out_vec[0] = a; // w
        out_vec[1] = b; // x
        out_vec[2] = b; // y
        out_vec[3] = c; // z
    end

    assign w = out_vec[0];
    assign x = out_vec[1];
    assign y = out_vec[2];
    assign z = out_vec[3];

endmodule