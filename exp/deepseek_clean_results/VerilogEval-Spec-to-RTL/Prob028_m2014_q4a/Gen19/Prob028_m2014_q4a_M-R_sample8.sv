module TopModule (
    input d,
    input ena,
    output reg q
);

always @(d or ena) begin
    if (ena) begin
        q = d;
    end
    // Note: No else branch is needed - q retains its value when ena is low
end

endmodule