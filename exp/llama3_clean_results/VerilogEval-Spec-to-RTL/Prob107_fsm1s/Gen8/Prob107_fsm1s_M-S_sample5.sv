module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

reg state; // using a single bit for two states
parameter B = 1'b1;
parameter A = 1'b0;

// Output logic
assign out = state;

// State register
always @(posedge clk) begin
    if(reset) begin
        state <= B;
    end else begin
        state <= (state == B) ? in : !in;
    end
end

endmodule