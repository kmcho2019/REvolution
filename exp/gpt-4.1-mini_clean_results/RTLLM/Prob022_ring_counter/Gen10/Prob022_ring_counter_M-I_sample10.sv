module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    reg [2:0] index;  // current '1' position from 0 to 7

    // Sequential logic to update the index on clk or reset
    always @(posedge clk or posedge reset) begin
        if (reset)
            index <= 3'd0;
        else
            index <= index + 3'd1;  // wraps around modulo 8 naturally due to 3 bits
    end

    // Combinational assignment of out using shift operator to avoid bit-select assignment
    always @(*) begin
        out = 8'b00000001 << index;
    end

endmodule