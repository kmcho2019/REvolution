module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);
    wire bc_or;
    assign bc_or = b | c;

    always @(*) begin
        // assign output from intermediate wire
        q = bc_or;
    end
endmodule