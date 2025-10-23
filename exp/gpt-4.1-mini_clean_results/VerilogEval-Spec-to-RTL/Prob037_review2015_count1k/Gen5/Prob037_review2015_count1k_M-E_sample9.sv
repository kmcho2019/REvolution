module TopModule(
    input clk,
    input reset,
    output reg [9:0] q
);

    // Units/Tens counter: counts 0 to 99 (7 bits enough for binary 0-99)
    reg [6:0] lower_count;  // 0-99
    // Hundreds counter: counts 0 to 9 (4 bits, but max 9)
    reg [3:0] hundred_count; // 0-9

    wire lower_wrap = (lower_count == 7'd99);
    wire hundred_wrap = (hundred_count == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            lower_count <= 7'd0;
            hundred_count <= 4'd0;
            q <= 10'd0;
        end else begin
            if (lower_wrap) begin
                lower_count <= 7'd0;
                if (hundred_wrap)
                    hundred_count <= 4'd0;
                else
                    hundred_count <= hundred_count + 1;
            end else begin
                lower_count <= lower_count + 1;
            end
            q <= {hundred_count, lower_count}; // Concatenate to 10-bit output
        end
    end

endmodule