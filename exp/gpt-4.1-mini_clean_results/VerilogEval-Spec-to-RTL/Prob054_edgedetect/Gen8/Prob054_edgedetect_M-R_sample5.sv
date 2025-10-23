module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        pedge <= (~prev_in) & in;  // Detect rising edge and register output simultaneously
        prev_in <= in;             // Update previous input
    end

endmodule