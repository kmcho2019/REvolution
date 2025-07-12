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
    if (L) select = 2'b00; // Select R
    else if (E) select = 2'b01; // Select w
    else select = 2'b10; // Select Q (hold current value)
end

always @(posedge clk) begin
    case (select)
        2'b00: Q <= R;
        2'b01: Q <= w;
        2'b10: Q <= Q; // Hold current value
        default: Q <= Q; // Default case to avoid latch inference
    endcase
end

endmodule