module TopModule(
    input x3,
    input x2,
    input x1,
    output reg f
);

// Refactored implementation using an always block with conditional statement.
always @(*) begin
    if ((~x3 & x2) || (x3 & x1)) begin
        f = 1'b1;
    end else begin
        f = 1'b0;
    end
end

endmodule