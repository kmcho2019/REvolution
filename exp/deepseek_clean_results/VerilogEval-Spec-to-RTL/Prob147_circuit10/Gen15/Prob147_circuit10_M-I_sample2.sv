module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;
reg [1:0] reset_counter = 2'b0;

always @(posedge clk) begin
    if (a == 0 && b == 0) begin
        reset_counter <= reset_counter + 1;
        if (reset_counter == 2'b11) begin  // After exactly 4 cycles
            state_reg <= 1'b0;
        end
    end
    else begin
        reset_counter <= 2'b0;
        if (a != b) begin
            state_reg <= ~state_reg;
        end
    end
end

assign q = state_reg ^ b;  // XOR operation
assign state = state_reg;

endmodule