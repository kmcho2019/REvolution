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
    // State update logic
    if (a == b) begin
        if (a == 0) begin
            reset_counter <= reset_counter + 1;
            if (reset_counter == 2'b11)  // After 4 cycles of a=b=0
                state_reg <= 1'b0;
        end
        else begin
            reset_counter <= 2'b0;
        end
    end
    else if (state_reg == 0) begin  // Toggle only when previous state was 0
        state_reg <= ~state_reg;
        reset_counter <= 2'b0;
    end
end

// Output logic
assign q = (state_reg & ~b) | (~state_reg & b);
assign state = state_reg;

endmodule