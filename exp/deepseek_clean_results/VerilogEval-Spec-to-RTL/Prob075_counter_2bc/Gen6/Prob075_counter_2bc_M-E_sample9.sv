module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// Reset value (weakly not-taken)
localparam RESET_VALUE = 2'b01;

// Next state calculation using arithmetic operations
wire [1:0] next_state = areset ? RESET_VALUE : 
                       (train_valid ? 
                           (train_taken ? 
                               (state == 2'b11 ? 2'b11 : state + 1'b1) : 
                               (state == 2'b00 ? 2'b00 : state - 1'b1)) : 
                           state);

// State register
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= RESET_VALUE;
    else
        state <= next_state;
end

endmodule