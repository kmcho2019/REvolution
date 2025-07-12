module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg [1:0] select;
always @(*) begin
    if (L) begin
        select <= 2'b01; // Select R
    end else if (E) begin
        select <= 2'b10; // Select w
    end else begin
        select <= 2'b00; // Hold Q (by selecting Q itself through a feedback loop, not directly implemented here for simplicity)
    end
end

always @(posedge clk) begin
    case (select)
        2'b01: Q <= R;
        2'b10: Q <= w;
        default: Q <= Q; // Hold the current value
    endcase
end

endmodule