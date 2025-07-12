module ring_counter (
    input wire clk,
    input wire reset,
    output reg [7:0] out
);

    reg [2:0] pos;  // position of the '1' bit, 0 to 7

    // Update position on clock
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pos <= 3'd0;
        end else begin
            if (pos == 3'd7)
                pos <= 3'd0;
            else
                pos <= pos + 3'd1;
        end
    end

    // Combinational logic to assign output bit vector based on pos
    always @(*) begin
        out = 8'b0;
        out[pos] = 1'b1;
    end

endmodule