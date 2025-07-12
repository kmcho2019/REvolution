module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;

// Asynchronous reset
initial state = 2'b00;
always @(posedge clk) begin
    if (!aresetn) begin
        state <= 2'b00;
    end else begin
        state <= {state[0], x};
    end
end

// Output logic
assign z = (state == 2'b10) && (x == 1'b1);

endmodule