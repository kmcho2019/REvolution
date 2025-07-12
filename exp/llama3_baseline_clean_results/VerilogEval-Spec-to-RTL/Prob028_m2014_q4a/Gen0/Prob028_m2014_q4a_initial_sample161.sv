module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*)
begin
    if (ena) begin
        q = d;
    end else begin
        // No need to do anything here, q will hold its value
    end
end

endmodule