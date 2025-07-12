module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

    reg [2:0] position;

    // Sequential logic to update position
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            position <= 3'd0; // start at bit 0 (LSB)
        end else begin
            position <= position + 3'd1;
        end
    end

    // Combinational assignment for output: one-hot with only the bit at 'position' set
    assign out = 8'b0000_0001 << position;

endmodule