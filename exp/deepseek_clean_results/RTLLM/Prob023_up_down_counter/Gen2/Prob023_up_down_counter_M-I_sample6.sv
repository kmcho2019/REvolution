module up_down_counter #(
    parameter WIDTH = 16
) (
    input clk,
    input reset,
    input up_down,
    input enable,
    output [WIDTH-1:0] count
);

// Split into 4-bit slices with carry lookahead
wire [3:0] count_slice [WIDTH/4-1:0];
wire [WIDTH/4:0] carry;

assign carry[0] = 1'b0;
assign count = {count_slice[3], count_slice[2], count_slice[1], count_slice[0]};

genvar i;
generate
    for (i = 0; i < WIDTH/4; i = i + 1) begin : COUNTER_SLICE
        counter_4bit_slice u_slice (
            .clk(clk),
            .reset(reset),
            .enable(enable & (|carry[i] | (i == 0)), // Clock gating
            .up_down(up_down),
            .cin(carry[i]),
            .cout(carry[i+1]),
            .count(count_slice[i])
        );
    end
endgenerate

endmodule

module counter_4bit_slice (
    input clk,
    input reset,
    input enable,
    input up_down,
    input cin,
    output cout,
    output reg [3:0] count
);

wire [3:0] next_count;
wire next_cout;

// Shared adder/subtractor logic
assign {next_cout, next_count} = up_down ? 
    {1'b0, count} + {3'b0, cin} + 4'd1 : 
    {1'b0, count} - {3'b0, cin} - 4'd1;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0;
    end else if (enable) begin
        count <= next_count;
    end
end

assign cout = enable ? next_cout : 1'b0;

endmodule