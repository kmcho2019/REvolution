module TopModule(
    input  [5:0] y,
    input        w,
    output reg   Y1,
    output reg   Y3
);
    always @(*) begin
        // Default values
        Y1 = 1'b0;
        Y3 = 1'b0;

        // Next state logic for Y1 (state B input)
        if (y[0] && w)
            Y1 = 1'b1;

        // Next state logic for Y3 (state D input)
        if (~w && (y[1] || y[2] || y[4] || y[5]))
            Y3 = 1'b1;
    end
endmodule