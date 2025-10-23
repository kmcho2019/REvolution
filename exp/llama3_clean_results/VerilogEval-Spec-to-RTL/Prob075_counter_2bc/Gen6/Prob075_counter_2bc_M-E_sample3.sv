module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg; // Internal register to hold the counter value
assign state = state_reg; // Continuous assignment to output the counter value

// Control signals for the ALU
wire increment;
wire decrement;

// ALU control logic
assign increment = train_valid && train_taken;
assign decrement = train_valid && ~train_taken;

// Generic ALU for increment and decrement operations
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // Asynchronous reset
    end else if (increment) begin
        if (state_reg == 2'b11) begin
            state_reg <= 2'b11; // Saturate at maximum value
        end else begin
            state_reg <= state_reg + 1; // Increment
        end
    end else if (decrement) begin
        if (state_reg == 2'b00) begin
            state_reg <= 2'b00; // Saturate at minimum value
        end else begin
            state_reg <= state_reg - 1; // Decrement
        end
    end else begin
        state_reg <= state_reg; // Maintain current value when not training
    end
end

endmodule