module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg [1:0] counter; // Counter to track states (0 - OFF, 1 - ON)

// Counter update logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        counter <= 0; // Reset to OFF state
    end else begin
        case (counter)
            0: if (j) counter <= 1; // Transition from OFF to ON on j=1
            1: if (k) counter <= 0; // Transition from ON to OFF on k=1
            default: counter <= 0; // Default to OFF state
        endcase
    end
end

// Output logic directly from counter
assign out = (counter == 1) ? 1'b1 : 1'b0;

endmodule