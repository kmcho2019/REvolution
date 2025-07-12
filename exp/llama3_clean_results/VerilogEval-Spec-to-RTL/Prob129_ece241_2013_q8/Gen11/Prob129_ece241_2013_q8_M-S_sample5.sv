module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg prev_x;

// Asynchronous reset and sequential logic
always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        prev_x <= 1'b0;
    end else begin
        prev_x <= x;
    end
end

// Output logic
assign z = (prev_x == 1'b0) && x;

endmodule