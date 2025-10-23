module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

// Next-state logic for y[1]
reg Y1_next;

always @(*)
begin
    // Default value for Y1_next
    Y1_next = 0;

    // Conditions to set Y1_next to 1
    if ((y == 3'b001 && w == 1) || // B -> D
        (y == 3'b100 && w == 1) || // C -> D
        (y == 3'b101 && w == 0) || // F -> C
        (y == 3'b110) ||         // E (any w)
        (y == 3'b111 && w == 0))  // F -> C
    begin
        Y1_next = 1;
    end
end

// Continuous assignment for output Y1
assign Y1 = y[1];

endmodule