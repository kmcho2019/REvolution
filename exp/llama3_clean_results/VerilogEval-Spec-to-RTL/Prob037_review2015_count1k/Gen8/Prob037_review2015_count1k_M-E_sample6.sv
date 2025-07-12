module TopModule #(
    parameter WIDTH = 10,
    parameter MAX_VALUE = 999
)(
    input clk,
    input reset,
    output [WIDTH-1:0] q
);

reg [WIDTH-1:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= {WIDTH{1'b0}};
    end else if (count == MAX_VALUE) begin
        count <= {WIDTH{1'b0}};
    end else begin
        count <= count + {WIDTH{1'b1}};
    end
end

assign q = count;

endmodule