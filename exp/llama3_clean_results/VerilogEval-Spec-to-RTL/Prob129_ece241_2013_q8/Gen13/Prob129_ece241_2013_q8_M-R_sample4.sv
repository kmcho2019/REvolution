module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg prev_x, prev_prev_x;

// Asynchronous reset and sequential logic
always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        // Reset previous values on asynchronous reset
        prev_x <= 1'b0;
        prev_prev_x <= 1'b0;
    end else begin
        // Update previous values on the positive clock edge
        prev_prev_x <= prev_x;
        prev_x <= x;
    end
end

// Output logic: Assert z when the sequence "101" is detected
assign z = (prev_prev_x == 1'b1) && (prev_x == 1'b0) && (x == 1'b1);

endmodule