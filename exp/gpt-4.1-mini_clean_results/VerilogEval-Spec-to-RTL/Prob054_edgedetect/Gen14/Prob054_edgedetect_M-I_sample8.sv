module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        // Update pedge only when a rising edge is detected on bits
        pedge   <= (~prev_in) & in;
        prev_in <= in;
    end

endmodule