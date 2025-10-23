module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg [0:0] counter; // 1-bit counter to represent the states

// Counter update logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        counter <= 1'b0; // Reset to OFF state
    end else begin
        case ({j, k})
            2'b01: counter <= 1'b1; // Transition from OFF to ON
            2'b11: counter <= 1'b0; // Transition from ON to OFF
            default: counter <= counter; // Stay in the current state
        endcase
    end
end

// Output logic directly from counter
assign out = counter;

endmodule