module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

// State machine implementation of JK flip-flop
always @(posedge clk) begin
    case ({j, k})
        2'b00: Q <= Q;       // Hold state
        2'b01: Q <= 1'b0;     // Reset
        2'b10: Q <= 1'b1;     // Set
        2'b11: Q <= ~Q;       // Toggle
    endcase
end

endmodule