module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// State encoding with meaningful names
localparam WEAKLY_NOT_TAKEN = 2'b01;  // Reset state
localparam MIN_STATE = 2'b00;
localparam MAX_STATE = 2'b11;

// Next state calculation with optimized logic structure
wire [1:0] next_state = areset ? WEAKLY_NOT_TAKEN :
                       train_valid ? 
                       (train_taken ? (state == MAX_STATE ? MAX_STATE : state + 1'b1) :
                                     (state == MIN_STATE ? MIN_STATE : state - 1'b1)) :
                       state;

// State register with async reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= WEAKLY_NOT_TAKEN;
    else
        state <= next_state;
end

endmodule