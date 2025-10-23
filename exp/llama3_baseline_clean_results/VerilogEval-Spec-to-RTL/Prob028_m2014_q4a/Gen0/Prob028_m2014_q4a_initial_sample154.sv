module TopModule (
    input  d,
    input  ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q <= d;
    end else begin
        // No explicit action needed here, q will retain its value
        // due to the reg type declaration
    end
end

endmodule