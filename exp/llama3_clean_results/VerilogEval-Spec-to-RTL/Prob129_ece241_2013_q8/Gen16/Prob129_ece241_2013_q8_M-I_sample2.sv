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

// Output logic simplified for potential better synthesis
assign z = (prev_prev_x && !prev_x && x);

endmodule