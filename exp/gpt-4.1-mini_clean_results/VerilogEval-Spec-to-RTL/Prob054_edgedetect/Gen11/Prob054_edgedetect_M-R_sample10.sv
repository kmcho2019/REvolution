module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    // Register previous input on clock edge
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Register pedge output one cycle after 0-to-1 transition detection
    always @(posedge clk) begin
        pedge <= (~prev_in) & in;
    end

endmodule