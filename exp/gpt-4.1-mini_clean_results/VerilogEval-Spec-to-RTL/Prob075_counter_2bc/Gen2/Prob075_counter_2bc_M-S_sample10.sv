module TopModule (
    input        clk,
    input        areset,
    input        train_valid,
    input        train_taken,
    output reg [1:0] state
);

    wire [2:0] next_plus_one = state + 1;
    wire [2:0] next_minus_one = state - 1;

    wire [1:0] next_state = train_valid ?
                            (train_taken ? 
                             (next_plus_one > 3 ? 2'b11 : next_plus_one[1:0]) :
                             (state == 2'b00 ? 2'b00 : next_minus_one[1:0]))
                            : state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;
        else
            state <= next_state;
    end

endmodule