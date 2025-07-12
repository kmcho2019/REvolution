module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg  [7:0] out
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

    // Combinational output generation based on position
    always @(*) begin
        integer i;
        out = 8'b0;
        out[position] = 1'b1;
    end

endmodule