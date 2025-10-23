module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg; // Internal register to hold the counter value
assign state = state_reg; // Continuous assignment to output the counter value

// Combinational logic to calculate the next state
reg [1:0] next_state;
always @(*) begin
    if (train_valid) begin
        if (train_taken) begin
            case (state_reg)
                2'b00: next_state = 2'b01;
                2'b01: next_state = 2'b10;
                2'b10: next_state = 2'b11;
                2'b11: next_state = 2'b11;
                default: next_state = 2'b00;
            endcase
        end else begin
            case (state_reg)
                2'b00: next_state = 2'b00;
                2'b01: next_state = 2'b00;
                2'b10: next_state = 2'b01;
                2'b11: next_state = 2'b10;
                default: next_state = 2'b00;
            endcase
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

endmodule