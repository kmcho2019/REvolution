module TopModule (
    input             clk,
    input      [7:0]  in,
    output reg [7:0]  pedge
);

    reg [7:0] prev;
    reg [7:0] curr;

    always @(posedge clk) begin
        prev  <= curr;
        curr  <= in;
        pedge <= (~prev) & curr;
    end

endmodule