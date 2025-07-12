module TopModule(
    input d,
    input ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q <= d;
    end else begin
        q <= q; // This is not necessary in this case as q is a reg and will hold its value
    end
end

endmodule