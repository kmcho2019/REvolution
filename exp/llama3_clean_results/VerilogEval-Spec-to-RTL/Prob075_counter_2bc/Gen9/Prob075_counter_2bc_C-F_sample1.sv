module TopModule(
    input           clk,
    input           areset,
    input           train_valid,
    input           train_taken,
    output reg [1:0] state
);

// Control signals for the ALU
wire increment;
wire decrement;

// ALU control logic using a simplified state transition approach
assign increment = train_valid && train_taken;
assign decrement = train_valid && ~train_taken;

// Generic ALU for increment and decrement operations
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Asynchronous reset to weakly not-taken state
    end else if (increment) begin
        if (state == 2'b11) begin
            state <= 2'b11; // Saturate at maximum value 3
        end else begin
            state <= state + 1; // Increment
        end
    end else if (decrement) begin
        if (state == 2'b00) begin
            state <= 2'b00; // Saturate at minimum value 0
        end else begin
            state <= state - 1; // Decrement
        end
    end else begin
        state <= state; // Maintain current value when not training
    end
end

endmodule