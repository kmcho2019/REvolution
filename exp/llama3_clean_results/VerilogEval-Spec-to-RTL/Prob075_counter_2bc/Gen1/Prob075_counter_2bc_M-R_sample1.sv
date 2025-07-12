module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg;
wire [1:0] next_state;

// Combinational logic to determine the next state
always @(*) begin
    if (train_valid) begin
        if (train_taken) begin
            next_state = (state_reg == 2'b11)? 2'b11 : state_reg + 1'b1;
        end else begin
            next_state = (state_reg == 2'b00)? 2'b00 : state_reg - 1'b1;
        end
    end else begin
        next_state = state_reg;
    end
end

// Sequential logic to update the state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01;
    end else begin
        state_reg <= next_state;
    end
end

// Continuous assignment to output the state
assign state = state_reg;

endmodule