module TopModule (
    input  clk,
    input  reset,
    output reg [31:0] q
);

    wire feedback;
    wire [31:0] q_next;

    assign feedback = q[0];
    assign q_next[31] = feedback ^ q[31] ^ q[21] ^ q[1];
    assign q_next[30:0] = q[31:1];

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= q_next;
        end
    end

endmodule