module incrementer(
    input [15:0] in,
    output reg [15:0] out
);

    always @(*) begin
        out = in + 1;
    end

endmodule

module decrementer(
    input [15:0] in,
    output reg [15:0] out
);

    always @(*) begin
        out = in - 1;
    end

endmodule

module up_down_counter #(
    parameter WIDTH = 16
)(
    input clk,
    input reset,
    input up_down,
    output reg [WIDTH-1:0] count
);

    reg [WIDTH-1:0] next_count;

    incrementer incr(
        .in(count),
        .out(next_count)
    );

    decrementer decr(
        .in(count),
        .out(next_count)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 'd0;
        end else if (up_down) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end

endmodule