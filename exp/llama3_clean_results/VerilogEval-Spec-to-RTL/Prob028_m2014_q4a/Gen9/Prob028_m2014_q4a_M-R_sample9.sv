module TopModule(
    input  d,
    input  ena,
    output reg q
);

// Use an always block sensitive to changes in 'ena' and 'd'
always @(d or ena) begin
    if (ena) begin
        q = d; // Update q when ena is high
    end
end

endmodule