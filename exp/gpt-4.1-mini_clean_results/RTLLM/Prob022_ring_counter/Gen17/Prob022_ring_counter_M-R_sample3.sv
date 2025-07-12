module ring_counter (
    input  clk,
    input  reset,
    output [7:0] out
);

    reg [2:0] position; // position of the '1' bit (0 to 7)

    // Sequential logic: increment position modulo 8, reset to 0
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            position <= 3'd0;
        end else begin
            position <= position + 3'd1;
        end
    end

    // Combinational logic: decode position to one-hot output
    assign out = 8'b1 << position;

endmodule