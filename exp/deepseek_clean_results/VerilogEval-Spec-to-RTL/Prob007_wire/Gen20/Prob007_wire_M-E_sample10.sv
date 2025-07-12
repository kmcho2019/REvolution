module RegisteredWire (
    input clk,
    input in,
    output reg out
);
    always @(posedge clk) begin
        out <= in;
    end
endmodule

module TopModule (
    input clk,
    input in,
    output out
);
    RegisteredWire reg_wire (
        .clk(clk),
        .in(in),
        .out(out)
    );
endmodule