module BCDCounter(
    input clk,
    input reset,
    output [3:0] count
);

reg [3:0] current_count;

always @(posedge clk) begin
    if (reset) begin
        current_count <= 'd0;
    end else if (current_count == 9) begin
        current_count <= 'd0;
    end else begin
        current_count <= current_count + 1'd1;
    end
end

assign count = current_count;

endmodule

module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [3:0] hundreds;
reg [3:0] tens;
reg [3:0] ones;

always @(posedge clk) begin
    if (reset) begin
        hundreds <= 'd0;
        tens <= 'd0;
        ones <= 'd0;
    end else begin
        if (ones == 9) begin
            ones <= 'd0;
            if (tens == 9) begin
                tens <= 'd0;
                if (hundreds == 9) begin
                    hundreds <= 'd0;
                end else begin
                    hundreds <= hundreds + 1'd1;
                end
            end else begin
                tens <= tens + 1'd1;
            end
        end else begin
            ones <= ones + 1'd1;
        end
    end
end

assign q = {hundreds, tens, ones};

endmodule