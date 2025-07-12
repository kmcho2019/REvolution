module StateBNext(
    input  [5:0] y,
    input  w,
    output reg Y1
);

    // Directly compute the value of Y1 using an assign statement
    always @(*) begin
        Y1 = y[0] && w;
    end

endmodule

module StateDNext(
    input  [5:0] y,
    input  w,
    output reg Y3
);

    // Directly compute the value of Y3 using an assign statement
    always @(*) begin
        Y3 = ~w && (y[1] || y[2] || y[4] || y[5]);
    end

endmodule

module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    // Instantiate the separate modules for Y1 and Y3
    StateBNext stateB(.y(y),.w(w),.Y1(Y1));
    StateDNext stateD(.y(y),.w(w),.Y3(Y3));

endmodule