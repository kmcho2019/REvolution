module TopModule(
    input  in,
    output reg out
);
    // Using an always block for combinational assignment
    always @(*) begin
        out = in;
    end
endmodule