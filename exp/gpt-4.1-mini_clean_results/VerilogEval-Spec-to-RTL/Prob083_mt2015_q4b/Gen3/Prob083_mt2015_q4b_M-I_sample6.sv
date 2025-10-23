module TopModule(
    input wire x,
    input wire y,
    output reg z
);
    always @(*) begin
        // Combinational logic matching XNOR behavior
        if (x == y)
            z = 1'b1;
        else
            z = 1'b0;
    end
endmodule