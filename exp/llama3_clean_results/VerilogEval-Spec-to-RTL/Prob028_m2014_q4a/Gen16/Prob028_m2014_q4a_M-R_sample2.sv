module TopModule(
    input  d,
    input  ena,
    output reg q
);
// Use an always block with a sensitivity list that includes 'ena' and 'd'
always @(*) begin
    // If 'ena' is high, assign 'd' to 'q'
    if (ena) begin
        q <= d;
    end
    // If 'ena' is low, retain the current value of 'q'
    else begin
        q <= q;
    end
end

endmodule