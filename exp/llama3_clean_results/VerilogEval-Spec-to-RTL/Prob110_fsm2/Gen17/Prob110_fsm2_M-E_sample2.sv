module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg counter; // single-bit counter

// Counter update logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        counter <= 0; // reset to OFF state
    end else begin
        case ({j, k})
            2'b01: counter <= 1; // transition from OFF to ON
            2'b10: counter <= 0; // transition from ON to OFF
            default: counter <= counter; // no change
        endcase
    end
end

// Output logic directly from counter
assign out = counter;

endmodule