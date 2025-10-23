module TopModule(
    input clk,
    input j,
    input k,
    output reg Q = 0 // Initialize Q to 0, arbitrary default state
);

always @(posedge clk) begin
    case ({j, k})
        2'b00: Q <= Q; // Qold
        2'b01: Q <= 0;
        2'b10: Q <= 1;
        2'b11: Q <= ~Q; // ~Qold
    endcase
end

endmodule