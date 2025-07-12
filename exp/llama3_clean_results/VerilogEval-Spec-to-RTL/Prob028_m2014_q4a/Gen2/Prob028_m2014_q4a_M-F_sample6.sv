module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(d or ena) begin
    if (ena) begin
        q <= d;
    end
    // No explicit action needed when ena is low; q retains its value
end

endmodule