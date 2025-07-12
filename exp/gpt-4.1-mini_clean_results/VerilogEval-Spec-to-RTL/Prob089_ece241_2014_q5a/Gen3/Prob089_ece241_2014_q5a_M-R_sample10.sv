module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // State encoding using parameters
    localparam BEFORE_ONE = 1'b0;
    localparam AFTER_ONE  = 1'b1;

    reg state;
    wire next_state;
    wire next_z;

    // Next-state combinational logic
    assign next_state = (state == BEFORE_ONE) ? (x ? AFTER_ONE : BEFORE_ONE) : AFTER_ONE;

    // Moore output logic: output depends only on current state and input x
    assign next_z = (state == BEFORE_ONE) ? x : ~x;

    // Sequential logic with asynchronous reset, updating state and output synchronously on clock
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= BEFORE_ONE;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
        end
    end

endmodule