module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input [WIDTH-1:0] in,
    output reg [WIDTH-1:0] pedge,
    input reset // Optional reset (active high)
);

    reg [WIDTH-1:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= {WIDTH{1'b0}};
            pedge <= {WIDTH{1'b0}};
        end
        else begin
            prev_in <= in;
            pedge <= in & ~prev_in;
        end
    end

endmodule