module TopModule (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (a) begin
        state <= ~state; // Toggle state when a is high
    end else begin
        state <= state; // State remains the same when a is low
    end
end

always @(*) begin
    if (a) begin
        q <= state; // q is determined by state when a is high
    end else if (b) begin
        q <= 1'b1; // q is high when a is low and b is high
    end else begin
        q <= 1'b0; // q is low when a and b are low
    end
end

endmodule