module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    // Lower counter: 0 to 9 (4 bits enough)
    reg [3:0] lower;
    // Upper counter: 0 to 99 (7 bits enough)
    reg [6:0] upper;

    wire lower_max = (lower == 4'd9);
    wire upper_max = (upper == 7'd99);

    always @(posedge clk) begin
        if (reset) begin
            lower <= 4'd0;
            upper <= 7'd0;
            q <= 10'd0;
        end else begin
            if (lower_max) begin
                lower <= 4'd0;
                if (upper_max) begin
                    upper <= 7'd0;
                    q <= 10'd0;
                end else begin
                    upper <= upper + 7'd1;
                    q <= (upper + 7'd1) * 10;
                end
            end else begin
                lower <= lower + 4'd1;
                q <= upper * 10 + (lower + 4'd1);
            end
        end
    end

endmodule