module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

always @(posedge clk) begin
    if (b) begin
        if (!a)
            state <= ~state;
        else
            state <= 1'b0;
    end
    else begin
        state <= state; // Hold state
    end
end

assign q = state;

endmodule