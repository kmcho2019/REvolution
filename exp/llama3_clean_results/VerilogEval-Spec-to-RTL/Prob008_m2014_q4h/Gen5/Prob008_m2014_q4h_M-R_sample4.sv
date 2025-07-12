module TopModule(
    input  in,
    output reg out // Declare out as reg for procedural assignment
);
    always @(*) begin
        out = in; // Procedural assignment within an always block
    end
endmodule