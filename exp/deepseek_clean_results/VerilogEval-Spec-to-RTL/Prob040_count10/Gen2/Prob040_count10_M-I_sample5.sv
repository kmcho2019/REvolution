module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] next_q;
reg [3:0] gray_count;
reg count_en;

// Gray code encoding
always @(*) begin
    case(q)
        4'b0000: gray_count = 4'b0000;
        4'b0001: gray_count = 4'b0001;
        4'b0010: gray_count = 4'b0011;
        4'b0011: gray_count = 4'b0010;
        4'b0100: gray_count = 4'b0110;
        4'b0101: gray_count = 4'b0111;
        4'b0110: gray_count = 4'b0101;
        4'b0111: gray_count = 4'b0100;
        4'b1000: gray_count = 4'b1100;
        4'b1001: gray_count = 4'b1101;
        default: gray_count = 4'b0000;
    endcase
end

// Clock gating control
always @(posedge clk) begin
    if (reset) begin
        count_en <= 1'b1;
    end else begin
        count_en <= (q != 4'b1001);
    end
end

// Counter logic with registered comparison
always @(posedge clk) begin
    if (reset) begin
        next_q <= 4'b0000;
    end else if (count_en) begin
        next_q <= (q == 4'b1001) ? 4'b0000 : q + 1;
    end
end

// Output register
always @(posedge clk) begin
    q <= next_q;
end

endmodule