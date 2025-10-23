module Stage1(
    input clk,
    input reset,
    input enable,
    output [2:0] count,
    output carry
);

reg [2:0] current_count;

always @(posedge clk) begin
    if (reset) begin
        current_count <= 3'd0;
    end else if (enable) begin
        if (current_count == 3'd9) begin
            current_count <= 3'd0;
        end else begin
            current_count <= current_count + 1;
        end
    end
end

assign count = current_count;
assign carry = (current_count == 3'd9);

endmodule

module Stage2(
    input clk,
    input reset,
    input enable,
    input carry_in,
    output [6:0] count,
    output carry
);

reg [6:0] current_count;

always @(posedge clk) begin
    if (reset) begin
        current_count <= 7'd0;
    end else if (enable) begin
        if (current_count == 7'd99) begin
            current_count <= 7'd0;
        end else if (carry_in) begin
            current_count <= current_count + 1;
        end
    end
end

assign count = current_count;
assign carry = (current_count == 7'd99);

endmodule

module Stage3(
    input clk,
    input reset,
    input enable,
    input carry_in,
    output [9:0] count
);

reg [9:0] current_count;

always @(posedge clk) begin
    if (reset) begin
        current_count <= 10'd0;
    end else if (enable) begin
        if (current_count == 10'd999) begin
            current_count <= 10'd0;
        end else if (carry_in) begin
            current_count <= current_count + 1;
        end
    end
end

assign count = current_count;

endmodule

module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

wire enable;
wire carry1;
wire carry2;

assign enable = 1'b1;

Stage1 stage1_instance(
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .count(),
    .carry(carry1)
);

Stage2 stage2_instance(
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .carry_in(carry1),
    .count(),
    .carry(carry2)
);

Stage3 stage3_instance(
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .carry_in(carry2),
    .count(q)
);

endmodule