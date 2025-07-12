module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    reg [2:0] index;  // current '1' position from 0 to 7

    // Sequential logic to update the index on clk or reset
    always @(posedge clk or posedge reset) begin
        if (reset)
            index <= 3'd0;
        else
            index <= index + 3'd1;  // wraps around automatically modulo 8
    end

    // Combinational logic to generate output from index
    always @(*) begin
        out = 8'b0;
        out[index] = 1'b1;
    end

endmodule