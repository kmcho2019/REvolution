module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01; // weakly not-taken
    else if (train_valid) begin
        if (train_taken && (state != 2'b11))
            state <= state + 1;
        else if (!train_taken && (state != 2'b00))
            state <= state - 1;
        else
            state <= state; // hold current state
    end
    else
        state <= state; // hold current state
end

endmodule