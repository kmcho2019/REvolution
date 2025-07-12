module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg prev_x;
reg prev_prev_x;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        prev_x <= 1'b0;
        prev_prev_x <= 1'b0;
    end else begin
        prev_prev_x <= prev_x;
        prev_x <= x;
    end
end

// Output logic
assign z = (prev_prev_x == 1'b1) && (prev_x == 1'b0) && (x == 1'b1);

endmodule