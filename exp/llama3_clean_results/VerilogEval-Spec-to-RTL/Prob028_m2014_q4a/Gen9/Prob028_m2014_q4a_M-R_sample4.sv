module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(d or ena) begin
    if (ena) begin
        q <= d; // When ena is high, q follows d
    end else begin
        // No explicit action needed; q retains its previous value implicitly
    end
end

endmodule