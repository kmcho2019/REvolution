module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;  // 0=OFF, 1=ON

    // Combined state transition and reset logic
    wire next_state = reset ? 1'b0 : 
                     (state == 1'b0) ? (j ? 1'b1 : 1'b0) :
                     (k ? 1'b0 : 1'b1);

    // State register update
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output assignment (Moore machine)
    assign out = state;

endmodule