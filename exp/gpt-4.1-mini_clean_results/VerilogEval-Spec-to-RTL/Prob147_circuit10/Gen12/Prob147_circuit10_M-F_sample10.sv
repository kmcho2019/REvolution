module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

always @(posedge clk) begin
    if (b == 1'b0) begin
        // No change
        state <= state;
    end else begin // b == 1
        if (a == 1'b0) begin
            state <= ~state;
        end else begin
            state <= 1'b0;
        end
    end
end

assign q = state;

endmodule