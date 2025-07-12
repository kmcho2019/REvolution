module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);
    wire [31:0] next_q;
    assign next_q = (q[0]) ? (q >> 1) ^ 32'h80200003 : (q >> 1);

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= next_q;
    end
endmodule