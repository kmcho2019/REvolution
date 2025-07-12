module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(d or ena)
begin
    if (ena)
    begin
        q <= d;
    end
    // No else, as the value of q remains unchanged when ena is 0
end

endmodule