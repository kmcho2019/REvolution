module TopModule (
    input  wire clk,
    input  wire d,
    input  wire r,
    output reg  q
);

// Enable update only if reset is asserted or input differs from current output
wire update_en = r | (d != q);

always @(posedge clk) begin
    if (update_en) begin
        if (r)
            q <= 1'b0;
        else
            q <= d;
    end
end

endmodule