module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    // assign y1_next = (y == 3'b001 && w) || (y == 3'b100 && w) || (y == 3'b101 && w) || (y == 3'b101 && ~w);
    // For simplicity and since y is only 3 bits, 
    // we can use the following equation
    assign Y1 = ((y == 3'b001) && w) || 
               ((y == 3'b100) || (y == 3'b101)) && 
               (w || (y == 3'b101 && ~w));

endmodule