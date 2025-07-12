module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_d1;       // input delayed by one clock cycle
    reg [7:0] edge_d1;    // registered edge detection

    always @(posedge clk) begin
        in_d1    <= in;
        edge_d1  <= (~in_d1) & in;   // detect 0->1 transition between in_d1 and in
        pedge    <= edge_d1;         // output delayed one more cycle after detection
    end

endmodule