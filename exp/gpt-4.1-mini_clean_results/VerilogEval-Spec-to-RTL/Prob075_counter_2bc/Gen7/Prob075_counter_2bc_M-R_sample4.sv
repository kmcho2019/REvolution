module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    reg [1:0] next_state;

    // Combinational logic for next_state
    always @(*) begin
        if (train_valid) begin
            if (train_taken)
                next_state = (state == 2'd3) ? 2'd3 : state + 1;
            else
                next_state = (state == 2'd0) ? 2'd0 : state - 1;
        end else begin
            next_state = state;
        end
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;
        end else begin
            state <= next_state;
        end
    end

endmodule