module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output wire [7:0] out
);

    reg [2:0] state; // 3-bit state to index the position of '1'

    // State update: increment state or reset to 0
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= 3'b000;
        else
            state <= state + 3'b001; // automatically wraps from 7 to 0 due to 3-bit width
    end

    // Output logic: one-hot based on state index
    assign out = 8'b00000001 << state;

endmodule