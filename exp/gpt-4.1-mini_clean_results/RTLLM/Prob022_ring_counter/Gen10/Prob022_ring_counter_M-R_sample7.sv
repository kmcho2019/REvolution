module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

    reg [2:0] index;  // current '1' position from 0 to 7

    // Sequential logic to update the index on clk or reset
    always @(posedge clk or posedge reset) begin
        if (reset)
            index <= 3'd0;
        else
            index <= index + 3'd1;  // wraps around automatically modulo 8
    end

    // Continuous combinational assignment for output using shift
    assign out = 8'b1 << index;

endmodule