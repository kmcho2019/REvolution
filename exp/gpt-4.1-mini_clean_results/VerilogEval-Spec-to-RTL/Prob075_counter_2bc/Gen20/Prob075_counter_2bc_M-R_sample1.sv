module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    wire increment = train_valid & train_taken;
    wire decrement = train_valid & (~train_taken);

    wire [1:0] incremented = (state == 2'd3) ? 2'd3 : (state + 1);
    wire [1:0] decremented = (state == 2'd0) ? 2'd0 : (state - 1);

    wire [1:0] next_state = increment ? incremented :
                            decrement ? decremented :
                            state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;  // weakly not-taken reset state
        else
            state <= next_state;
    end

endmodule