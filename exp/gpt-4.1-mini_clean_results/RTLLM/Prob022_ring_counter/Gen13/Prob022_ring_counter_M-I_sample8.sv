module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output wire [7:0] out
);

    reg [2:0] position;  // Position of the single set bit [0..7]

    // Sequential logic to update position on clock and reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            position <= 3'd0;
        end else begin
            if (position == 3'd7)
                position <= 3'd0;
            else
                position <= position + 3'd1;
        end
    end

    // Combinational assignment of one-hot output from position
    assign out = 8'b1 << position;

endmodule