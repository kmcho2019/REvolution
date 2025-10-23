module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;
    wire next_state;

    // Next state logic (combinational)
    assign next_state = reset ? 1'b0 :  // Reset to OFF
                       state ? ~k :     // If ON, transition when k=1
                       j;               // If OFF, transition when j=1

    // State register (DFF)
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output logic (Moore)
    assign out = state;

endmodule