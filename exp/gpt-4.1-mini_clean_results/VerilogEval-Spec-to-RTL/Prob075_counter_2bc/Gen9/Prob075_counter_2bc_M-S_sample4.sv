module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;
        else if (train_valid)
            state <= train_taken ? (state == 2'd3 ? 2'd3 : state + 1)
                                 : (state == 2'd0 ? 2'd0 : state - 1);
    end

endmodule