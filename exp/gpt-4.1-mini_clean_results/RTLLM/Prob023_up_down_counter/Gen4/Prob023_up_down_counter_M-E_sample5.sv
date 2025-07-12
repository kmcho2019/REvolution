module up_down_counter #(
    parameter WIDTH = 16
)(
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [WIDTH-1:0] count
);

    wire [WIDTH-1:0] incremented;
    wire [WIDTH-1:0] decremented;
    reg [WIDTH-1:0] next_count;

    assign incremented = count + 1;
    assign decremented = count - 1;

    always @(*) begin
        if (up_down)
            next_count = incremented;
        else
            next_count = decremented;
    end

    always @(posedge clk) begin
        if (reset)
            count <= {WIDTH{1'b0}};
        else
            count <= next_count;
    end

endmodule