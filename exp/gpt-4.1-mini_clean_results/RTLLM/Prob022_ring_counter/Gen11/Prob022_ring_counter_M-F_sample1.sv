module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output wire [7:0] out
);

    // Internal index for the active bit position
    reg [2:0] position;

    always @(posedge clk or posedge reset) begin
        if (reset)
            position <= 3'd0;
        else begin
            if (position == 3'd7)
                position <= 3'd0;
            else
                position <= position + 3'd1;
        end
    end

    // Combinational output assignment: one-hot encoding by shifting 1
    assign out = 8'b1 << position;

endmodule