module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg prev_x;
reg seq_10;

// Asynchronous reset and sequential logic
always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        // Reset the previous input and sequence detection on asynchronous reset
        prev_x <= 1'b0;
        seq_10 <= 1'b0;
    end else begin
        // Update the previous input and sequence detection on the positive clock edge
        prev_x <= x;
        if (prev_x == 1'b0 && seq_10 == 1'b1) begin
            seq_10 <= 1'b0;
        end else if (x == 1'b1) begin
            seq_10 <= 1'b1;
        end
    end
end

// Output logic: Assert z when the sequence "101" is detected
assign z = prev_x && seq_10 && x;

endmodule