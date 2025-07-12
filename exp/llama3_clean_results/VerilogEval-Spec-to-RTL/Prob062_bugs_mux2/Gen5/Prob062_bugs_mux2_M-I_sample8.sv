module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output reg [7:0] out // declare out as reg type
);

    always @(*) begin
        out = (sel)? b : a; // simple conditional statement
    end

endmodule