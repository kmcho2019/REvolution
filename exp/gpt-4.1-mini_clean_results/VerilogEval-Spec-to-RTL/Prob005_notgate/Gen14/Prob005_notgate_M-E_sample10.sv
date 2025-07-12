module TopModule (
    input  wire in,
    output reg  out
);
    // Procedural combinational logic for NOT gate
    always @(*) begin
        out = ~in;
    end
endmodule