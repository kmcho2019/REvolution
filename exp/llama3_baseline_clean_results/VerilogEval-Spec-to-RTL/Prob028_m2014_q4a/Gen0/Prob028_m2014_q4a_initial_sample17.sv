module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q <= d;
    end else begin
        // No action needed here, as q will hold its previous value
        // due to the nature of reg type and non-blocking assignment
    end
end

endmodule