module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;
reg [1:0] zero_counter = 2'b0;

always @(posedge clk) begin
    if (a == 0 && b == 0) begin
        zero_counter <= zero_counter + 1;
        if (zero_counter == 2'b11) begin
            state_reg <= 1'b0;
        end
    end
    else begin
        zero_counter <= 2'b0;
        if (a ^ b) begin
            state_reg <= ~state_reg;
        end
    end
end

assign q = state_reg ^ b;
assign state = state_reg;

endmodule