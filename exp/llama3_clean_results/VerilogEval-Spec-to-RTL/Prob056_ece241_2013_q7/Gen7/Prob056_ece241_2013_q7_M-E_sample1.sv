module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

reg [1:0] state; // 0: S0 (Q=0), 1: S1 (Q=1)

always @(posedge clk) begin
    case ({j, k})
        2'b00: state <= state; // Stay in current state
        2'b01: state <= 1'b1; // Transition to S1 (Q=1)
        2'b10: state <= 1'b0; // Transition to S0 (Q=0)
        2'b11: state <= ~state; // Toggle current state
    endcase
end

always @(*) begin
    Q = state; // Output Q based on current state
end

endmodule