module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg;
reg [1:0] next_state;

// Combinational logic to calculate the next state
always @(*) begin
    if (train_valid) begin
        if (train_taken) begin
            if (state_reg == 2'b11) begin
                next_state = 2'b11;
            end else begin
                next_state = state_reg + 1;
            end
        end else begin
            if (state_reg == 2'b00) begin
                next_state = 2'b00;
            end else begin
                next_state = state_reg - 1;
            end
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

assign state = state_reg; // Continuous assignment to output the counter value

endmodule