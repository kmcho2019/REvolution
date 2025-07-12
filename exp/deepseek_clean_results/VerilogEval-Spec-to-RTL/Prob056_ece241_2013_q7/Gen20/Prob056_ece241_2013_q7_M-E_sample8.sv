module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg state;

always @(posedge clk) begin
    case ({j, k})
        2'b00: state <= state;    // Hold state
        2'b01: state <= 1'b0;     // Reset
        2'b10: state <= 1'b1;     // Set
        2'b11: state <= ~state;   // Toggle
    endcase
end

assign Q = state;

endmodule