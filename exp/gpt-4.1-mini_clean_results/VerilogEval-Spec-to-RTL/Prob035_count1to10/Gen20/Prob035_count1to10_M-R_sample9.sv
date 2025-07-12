module TopModule (
    input        clk,
    input        reset,
    output [3:0] q
);

    reg [3:0] state;
    wire [3:0] next_state;

    // Next state logic: if state is 10, wrap to 1, else increment
    assign next_state = (state == 4'd10) ? 4'd1 : (state + 4'd1);

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 4'd1;
        else
            state <= next_state;
    end

    assign q = state;

endmodule