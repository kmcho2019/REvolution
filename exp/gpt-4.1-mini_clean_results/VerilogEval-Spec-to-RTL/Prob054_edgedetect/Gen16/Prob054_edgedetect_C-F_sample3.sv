module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] raw_pedge;

    assign raw_pedge = (~prev_in) & in;

    always @(posedge clk) begin
        prev_in <= in;
        pedge   <= raw_pedge;
    end

endmodule