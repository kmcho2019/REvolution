module TopModule (
    output reg one
);
    always @(*) begin
        one = 1'b1;  // Procedural assignment of constant high
    end
endmodule