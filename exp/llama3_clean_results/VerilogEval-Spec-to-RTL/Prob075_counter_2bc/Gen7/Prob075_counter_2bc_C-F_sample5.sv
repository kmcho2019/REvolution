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
        case (state)
            2'b00: state <= 2'b01; // Increment from 0 to 1
            2'b01: state <= 2'b10; // Increment from 1 to 2
            2'b10: state <= 2'b11; // Increment from 2 to 3
            2'b11: state <= 2'b11; // Saturate at maximum value 3
            default: state <= 2'b01; // Default to state 1
        endcase
    end else if (decrement) begin
        case (state)
            2'b00: state <= 2'b00; // Saturate at minimum value 0
            2'b01: state <= 2'b00; // Decrement from 1 to 0
            2'b10: state <= 2'b01; // Decrement from 2 to 1
            2'b11: state <= 2'b10; // Decrement from 3 to 2
            default: state <= 2'b01; // Default to state 1
        endcase
    end else begin
        state <= state; // Maintain current value when not training
    end
end

endmodule