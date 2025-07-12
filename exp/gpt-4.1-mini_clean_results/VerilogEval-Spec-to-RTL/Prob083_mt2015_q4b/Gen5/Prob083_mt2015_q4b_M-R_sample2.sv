module TopModule(
    input  wire x,
    input  wire y,
    output reg  z
);
    // Combinational always block to generate z based on x and y
    always @(*) begin
        if (x == y)
            z = 1'b1;
        else
            z = 1'b0;
    end
endmodule