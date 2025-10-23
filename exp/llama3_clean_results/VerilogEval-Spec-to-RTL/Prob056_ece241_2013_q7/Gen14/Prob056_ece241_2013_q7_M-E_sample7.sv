module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

reg [1:0] state;

always @(posedge clk) begin
    case({j, k})
        2'b00: state <= state; // Qold
        2'b01: state <= 1'b0;
        2'b10: state <= 1'b1;
        2'b11: state <= ~state[0]; // ~Qold
    endcase
    Q <= state[0];
end

endmodule