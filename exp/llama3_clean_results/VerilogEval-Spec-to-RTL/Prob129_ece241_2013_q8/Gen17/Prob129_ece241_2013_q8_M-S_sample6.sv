module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;

always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= 2'b00;
    end else begin
        state <= {state[0], x};
    end
end

assign z = (state == 2'b10) && x;

endmodule