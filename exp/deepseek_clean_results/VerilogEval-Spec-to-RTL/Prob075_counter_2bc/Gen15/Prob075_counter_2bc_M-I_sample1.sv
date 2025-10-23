module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

wire [1:0] next_state;
wire change_enabled = train_valid;
wire direction = train_taken;

// Optimized next state calculation using bitwise operations
assign next_state = change_enabled ? 
                   (direction ? (state + (state != 2'b11)) : 
                                (state - (state != 2'b00))) : 
                   state;

// State register with async reset and clock gating
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;
    else if (change_enabled)  // Clock gating effect
        state <= next_state;
end

endmodule