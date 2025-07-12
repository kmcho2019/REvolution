module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;  // 0=OFF, 1=ON
    wire next_state;

    // Combinational state transition logic
    assign next_state = reset ? 1'b0 : 
                       (state == 1'b0) ? (j ? 1'b1 : 1'b0) :
                       (k ? 1'b0 : 1'b1);

    // Sequential state update
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output assignment (Moore style)
    assign out = state;

endmodule