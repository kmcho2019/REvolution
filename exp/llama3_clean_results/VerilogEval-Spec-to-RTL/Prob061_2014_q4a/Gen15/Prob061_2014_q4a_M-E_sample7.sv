module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg temp_input;

always @(posedge clk) begin
    if (L) begin
        temp_input <= R;
    end else if (E) begin
        temp_input <= w;
    end else begin
        temp_input <= Q;
    end
    Q <= temp_input;
end

endmodule