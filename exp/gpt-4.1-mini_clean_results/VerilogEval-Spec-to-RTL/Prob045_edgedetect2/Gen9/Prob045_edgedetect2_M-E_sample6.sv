module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] anyedge_reg;

    always @(posedge clk) begin
        prev_in <= in;
        anyedge_reg <= in ^ prev_in;  // XOR current and previous input to detect edges
    end

    assign anyedge = anyedge_reg;

endmodule