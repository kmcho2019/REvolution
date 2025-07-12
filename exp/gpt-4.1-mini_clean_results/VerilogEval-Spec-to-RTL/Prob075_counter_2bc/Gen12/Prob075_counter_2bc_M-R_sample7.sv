module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    wire increment = train_valid & train_taken;
    wire decrement = train_valid & (~train_taken);

    wire [2:0] next_state_arith;

    // Compute next state with saturating arithmetic
    assign next_state_arith = increment ? 
                             ((state == 2'b11) ? 3'd3 : state + 1) :
                             (decrement ? ((state == 2'b00) ? 3'd0 : state - 1) : state);

    // Sequential logic with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // weakly not-taken reset state
        end else begin
            state <= next_state_arith[1:0];
        end
    end

endmodule