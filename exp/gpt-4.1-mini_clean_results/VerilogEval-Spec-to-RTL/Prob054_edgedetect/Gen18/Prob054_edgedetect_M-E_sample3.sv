module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] delayed_in;

    always @(posedge clk) begin
        // Generate pedge based on transition from delayed_in=0 to in=1
        pedge <= (~delayed_in) & in;
        // Store current input for next cycle comparison
        delayed_in <= in;
    end

endmodule