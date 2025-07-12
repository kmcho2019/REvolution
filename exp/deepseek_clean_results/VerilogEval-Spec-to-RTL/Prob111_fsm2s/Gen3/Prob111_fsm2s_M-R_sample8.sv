module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // State encoding
    reg state;  // 0=OFF, 1=ON
    wire next_state;

    // Next state logic using continuous assignment
    assign next_state = reset ? 1'b0 :  // Reset forces OFF
                       (state ? (k ? 1'b0 : 1'b1) :  // ON state logic
                       (j ? 1'b1 : 1'b0);            // OFF state logic

    // State register
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output assignment
    assign out = state;

endmodule