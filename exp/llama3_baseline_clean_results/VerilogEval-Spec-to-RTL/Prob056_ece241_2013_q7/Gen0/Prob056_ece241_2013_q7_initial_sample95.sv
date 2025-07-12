module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    case ({j, k})
        2'b00: Q <= Q; // Q remains the same
        2'b01: Q <= 1'b0; // Q becomes 0
        2'b10: Q <= 1'b1; // Q becomes 1
        2'b11: Q <= ~Q; // Q becomes the inverse of Qold
    endcase
end

endmodule