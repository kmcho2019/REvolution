module TopModule (
    input  wire        clk,
    input  wire [7:0]  in,
    output reg  [7:0]  pedge
);

    reg [7:0] in_d; // delayed input

    always @(posedge clk) begin
        pedge <= (in_d == 8'b0) ? 8'b0 : 8'b0; // Initialize to zero for clarity
        pedge <= (~in_d) & in;  // 0->1 transition detection on bits
        in_d <= in;
    end

endmodule