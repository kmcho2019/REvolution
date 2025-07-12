module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

always @(posedge clk)
begin
    if(a == 1'b0)
    begin
        if(q == 3'b111)  // when q reaches 7
            q <= 3'b000; // reset to 0
        else
            q <= q + 1'b1; // increment
    end
    else
    begin
        if(q == 3'b100) // when q is 4 and a is high, hold the value
            q <= 3'b100;
        else if (q != 3'b100) // when q is not 4, set it to 4
            q <= 3'b100;
    end
end

endmodule