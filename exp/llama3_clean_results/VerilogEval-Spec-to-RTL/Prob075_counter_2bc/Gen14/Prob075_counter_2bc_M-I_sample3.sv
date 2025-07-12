module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg; // Internal register to hold the counter value

// Combinational logic to calculate the next state
reg [1:0] next_state;
always @(*) begin
    if (train_valid) begin
        if (train_taken) begin
            next_state = (state_reg == 2'b11) ? 2'b11 : state_reg + 1;
        end else begin
            next_state = (state_reg == 2'b00) ? 2'b00 : state_reg - 1;
        end
    end else begin
        next_state = state_reg;
    end
end

// Sequential logic to update the state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // Asynchronous reset
    end else begin
        state_reg <= next_state;
    end
end

assign state = state_reg; // Directly assign state_reg to output

endmodule