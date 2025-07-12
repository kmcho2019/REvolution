module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output reg  w,
    output reg  x,
    output reg  y,
    output reg  z
);

    // Tri-state enable signals tied high (1'b1), effectively always driving outputs
    wire en = 1'b1;

    always @(*) begin
        w = en ? a : 1'bz;
        x = en ? b : 1'bz;
        y = en ? b : 1'bz;
        z = en ? c : 1'bz;
    end

endmodule