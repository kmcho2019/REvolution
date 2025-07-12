module TopModule(
    input  d,
    input  ena,
    output reg q = 0 // Initialize q to a default value
);

always @(d or ena) begin
    if (ena) begin
        q = d; // Blocking assignment for sequential update
    end
end

endmodule