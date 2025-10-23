module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    wire and_val = a & b; // shared internal signal

    assign out_assign = and_val;

    always @(*) begin
        out_alwaysblock = and_val;
    end

endmodule