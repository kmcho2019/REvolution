module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] prev_states;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        prev_states <= 2'b00;
    end else begin
        prev_states <= {prev_states[0], x};
    end
end

// Output logic
assign z = (prev_states == 2'b10) && x;

endmodule