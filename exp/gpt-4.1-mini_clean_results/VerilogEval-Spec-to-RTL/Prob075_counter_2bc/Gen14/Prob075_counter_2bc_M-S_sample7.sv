module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    reg [1:0] next_state;

    always @(*) begin
        next_state = state;
        if (train_valid) begin
            if (train_taken && (state != 2'd3))
                next_state = state + 1;
            else if (!train_taken && (state != 2'd0))
                next_state = state - 1;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // weakly not-taken reset state
        else
            state <= next_state;
    end

endmodule