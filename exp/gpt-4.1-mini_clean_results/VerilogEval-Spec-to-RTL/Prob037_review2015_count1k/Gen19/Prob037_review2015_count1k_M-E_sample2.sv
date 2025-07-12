module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    reg [3:0] lower_bcd;    // counts 0 to 9
    reg [5:0] upper_bin;    // counts 0 to 99

    wire lower_at_max = (lower_bcd == 4'd9);
    wire upper_at_max = (upper_bin == 6'd99);

    always @(posedge clk) begin
        if (reset) begin
            lower_bcd <= 4'd0;
            upper_bin <= 6'd0;
            q <= 10'd0;
        end else begin
            if (lower_at_max) begin
                lower_bcd <= 4'd0;
                if (upper_at_max) begin
                    upper_bin <= 6'd0;
                end else begin
                    upper_bin <= upper_bin + 6'd1;
                end
            end else begin
                lower_bcd <= lower_bcd + 4'd1;
            end
            q <= {upper_bin, lower_bcd};
        end
    end

endmodule