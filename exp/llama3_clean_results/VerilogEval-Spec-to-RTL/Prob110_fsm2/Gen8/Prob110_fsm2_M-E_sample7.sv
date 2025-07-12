module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg [1:0] counter; // 2-state counter (0: OFF, 1: ON)

// Counter update logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        counter <= 0; // Reset to OFF state
    end else begin
        case ({j, k})
            2'b01: counter <= 1; // j=1, k=0: Move to ON
            2'b10: counter <= 0; // j=0, k=1: Move to OFF
            default: counter <= counter; // No change
        endcase
    end
end

// Output logic directly from counter
assign out = (counter == 1) ? 1'b1 : 1'b0;

endmodule