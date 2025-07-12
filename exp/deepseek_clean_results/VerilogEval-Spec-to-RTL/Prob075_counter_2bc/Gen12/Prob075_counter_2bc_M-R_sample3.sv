module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// Reset value (weakly not-taken)
localparam RESET_VALUE = 2'b01;

// Next state calculation
wire [1:0] next_state;
assign next_state = areset ? RESET_VALUE :
                   (train_valid ? 
                       (train_taken ? 
                           (state + (state != 2'b11)) : 
                           (state - (state != 2'b00))) : 
                       state);

// State register
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= RESET_VALUE;
    else
        state <= next_state;
end

endmodule