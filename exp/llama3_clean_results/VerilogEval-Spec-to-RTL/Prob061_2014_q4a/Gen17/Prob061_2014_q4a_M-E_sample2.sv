module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg load, shift;

always @(posedge clk) begin
    if (L) begin
        load <= 1'b1;
        shift <= 1'b0;
    end else if (E) begin
        load <= 1'b0;
        shift <= 1'b1;
    end else begin
        load <= 1'b0;
        shift <= 1'b0;
    end
end

always @(posedge clk) begin
    if (load) begin
        Q <= R;
    end else if (shift) begin
        Q <= w;
    end else begin
        Q <= Q; // Retain current value
    end
end

endmodule