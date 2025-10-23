module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Internal signals for the counter
reg [1:0] count;

// Counter logic
always @(a or b or c or d) begin
    if (a + b + c + d == 0) count = 2'b00;
    else if (a + b + c + d == 1) count = 2'b01;
    else if (a + b + c + d == 2) count = 2'b10;
    else if (a + b + c + d == 3) count = 2'b11;
    else count = 2'b00; // default to 0 for counts greater than 3
end

// Parity checker logic
assign q = (count[0] == 0) ? 1'b1 : 1'b0;

endmodule