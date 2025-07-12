module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg state;

assign out = ~state;

always @(posedge clk) begin
    if(reset) begin
        state <= 1'b0;
    end else begin
        if(state == 1'b0 && in == 1'b0) begin
            state <= 1'b1;
        end else if(state == 1'b1 && in == 1'b0) begin
            state <= 1'b0;
        end
    end
end

endmodule