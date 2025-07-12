module TopModule (
    input wire       clk,
    input wire       reset,
    output reg [9:0] q
);

    reg [3:0] lower;    // Lower decimal digit (0-9)
    reg [6:0] upper;    // Upper decimal digits (0-99)

    // Multiply upper * 10 + lower to get count in binary
    wire [9:0] combined_count = (upper * 10) + lower;

    always @(posedge clk) begin
        if (reset) begin
            lower <= 4'd0;
            upper <= 7'd0;
            q <= 10'd0;
        end else begin
            if (lower == 4'd9) begin
                lower <= 4'd0;
                if (upper == 7'd99) begin
                    upper <= 7'd0;
                end else begin
                    upper <= upper + 7'd1;
                end
            end else begin
                lower <= lower + 4'd1;
            end

            q <= combined_count;
        end
    end

endmodule