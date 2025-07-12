module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// Next state logic implemented as lookup table
always @(*) begin
    case ({state, train_valid, train_taken})
        4'b00_1_0: state = 2'b00;  // Stay at min when decrementing
        4'b00_1_1: state = 2'b01;  // Increment from 0
        4'b01_1_0: state = 2'b00;  // Decrement from 1
        4'b01_1_1: state = 2'b10;  // Increment from 1
        4'b10_1_0: state = 2'b01;  // Decrement from 2
        4'b10_1_1: state = 2'b11;  // Increment from 2
        4'b11_1_0: state = 2'b10;  // Decrement from 3
        4'b11_1_1: state = 2'b11;  // Stay at max when incrementing
        default:   state = state;   // No change when not training
    endcase
end

// State register with async reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;
    else
        state <= next_state;
end

endmodule