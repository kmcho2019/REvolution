module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    always @(*)
    begin
        // Logic for Y1
        Y1 = y[0] && w;

        // Logic for Y3, considering the states where it is asserted and the transition condition
        Y3 = ~w && (y[3] || y[4] || y[5]);
    end

endmodule