module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

always @(posedge clk) begin
    if (a == 1'b0 && b == 1'b1) begin // Set state to 1 when a=0, b=1
        state <= 1'b1;
    end else if (a == 1'b1 && b == 1'b1) begin // Reset state to 0 when a=1, b=1
        state <= 1'b0;
    end else begin // Otherwise, retain current state
        state <= state;
    end
end

assign q = (state == 1'b1) || (a == 1'b1 && b == 1'b0); // q is 1 if state is 1 or a=1, b=0

endmodule