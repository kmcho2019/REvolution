module TopModule(
    input clk,
    input d,
    output reg q
);

reg master_latch;

always_latch begin
    if (~clk) begin
        master_latch = d;
    end
end

always_latch begin
    if (clk) begin
        q = master_latch;
    end
end

endmodule