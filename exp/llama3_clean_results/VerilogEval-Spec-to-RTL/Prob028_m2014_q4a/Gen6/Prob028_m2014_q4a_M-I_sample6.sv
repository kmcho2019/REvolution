module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(ena or d) begin
    if (ena) begin
        q <= d;  // Using non-blocking assignment for better synthesizability
    end
end

endmodule