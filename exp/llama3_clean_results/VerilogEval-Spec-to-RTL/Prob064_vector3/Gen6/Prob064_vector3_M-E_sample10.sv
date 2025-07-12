module TopModule(
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    reg [31:0] shift_reg;
    reg [1:0] counter;

    always @(posedge a[0] or posedge b[0] or posedge c[0] or posedge d[0] or posedge e[0] or posedge f[0]) begin
        case (counter)
            2'd0: shift_reg <= {a, b, c, d, e, f, 2'b11};
            2'd1: {w, x, y, z} <= shift_reg;
            default: ;
        endcase
        counter <= counter + 1;
    end

    always @(negedge a[0] or negedge b[0] or negedge c[0] or negedge d[0] or negedge e[0] or negedge f[0]) begin
        counter <= 0;
    end

endmodule