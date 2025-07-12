module pe (
    input wire clk,
    input wire rst,              // synchronous reset: active high
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] c
);

    reg [63:0] acc;

    always @(posedge clk) begin
        if (rst)
            acc <= 64'd0;
        else
            acc <= acc + a * b;
    end

    assign c = acc[31:0];

endmodule