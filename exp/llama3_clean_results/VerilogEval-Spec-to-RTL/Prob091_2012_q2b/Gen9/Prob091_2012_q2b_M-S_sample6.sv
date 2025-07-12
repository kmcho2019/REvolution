module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    // Directly implement the logic for Y1 and Y3 within TopModule
    always @(*) begin
        // State B (y[1]) can be reached from state A (y[0]) when w is 1
        Y1 = y[0] && w;
        
        // State D (y[3]) can be reached from states B, C, E, and F when w is 0
        Y3 = ~w && (y[1] || y[2] || y[4] || y[5]);
    end

endmodule