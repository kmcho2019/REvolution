module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

wire [2:0] incremented;
wire [2:0] decremented;
reg  [1:0] next_state;

// Compute incremented and decremented values with saturation
assign incremented = (state == 2'b11) ? 3'b011 : (state + 3'b001);
assign decremented = (state == 2'b00) ? 3'b000 : (state - 3'b001);

always @(*) begin
    if (!train_valid) begin
        next_state = state; // hold
    end else begin
        if (train_taken)
            next_state = incremented[1:0];
        else
            next_state = decremented[1:0];
    end
end

// Sequential logic with asynchronous positive edge reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01; // weakly not-taken
    else
        state <= next_state;
end

endmodule