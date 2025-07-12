module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

// Next state computation
wire next_state;
assign next_state = (j & k) ? ~Q :  // Toggle case
                    (j & ~k) ? 1'b1 :  // Set case
                    (~j & k) ? 1'b0 :  // Reset case
                    Q;  // Hold case (explicit)

// State update on clock edge
always @(posedge clk) begin
    Q <= next_state;
end

endmodule