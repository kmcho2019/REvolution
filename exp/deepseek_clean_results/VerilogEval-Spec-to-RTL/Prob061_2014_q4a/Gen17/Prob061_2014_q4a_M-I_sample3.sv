module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    if (L) begin       // Highest priority: load
        Q <= R;
    end
    else if (E) begin  // Next priority: shift
        Q <= w;
    end
    // Else retain value (minimal power)
end

endmodule