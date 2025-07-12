module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // 0 - Idle, 1 - Running
reg current_state; // current state for 2's complement generation

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to Idle state
        current_state <= 1'b0; // reset current state to 0
    end else if (state == 2'b00) begin
        state <= 2'b01; // transition to Running state when reset is released
    end else if (state == 2'b01) begin
        if (x == 1'b1) begin
            current_state <= ~current_state; // update current state
        end
        z <= ~current_state; // output is the inverse of current state
    end
end

endmodule