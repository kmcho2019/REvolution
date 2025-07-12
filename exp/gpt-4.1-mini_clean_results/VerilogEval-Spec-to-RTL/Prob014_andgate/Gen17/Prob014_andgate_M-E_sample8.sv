module TopModule (
    input  wire a,
    input  wire b,
    output reg  out
);

    // Combinational block that implements AND logic
    always @(*) begin
        out = a & b;
    end

endmodule