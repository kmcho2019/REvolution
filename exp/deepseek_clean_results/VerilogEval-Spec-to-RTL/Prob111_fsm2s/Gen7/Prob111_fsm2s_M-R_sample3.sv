module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;  // 0=OFF, 1=ON
    wire next_state;

    // Next state logic using continuous assignments
    assign next_state = (state == 1'b0) ? j :      // OFF state: transition on j
                       (state == 1'b1) ? ~k : 1'b0; // ON state: transition on ~k

    // State register
    always @(posedge clk) begin
        state <= reset ? 1'b0 : next_state;
    end

    // Output assignment
    assign out = state;

endmodule