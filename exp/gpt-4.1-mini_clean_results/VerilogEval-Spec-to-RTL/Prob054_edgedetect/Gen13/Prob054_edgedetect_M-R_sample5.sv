module TopModule (
    input             clk,
    input      [7:0]  in,
    output     [7:0]  pedge
);

    reg [7:0] current_in;
    reg [7:0] prev_in;

    // Update registers on clock edge
    always @(posedge clk) begin
        prev_in    <= current_in;
        current_in <= in;
    end

    // Positive edge detected when previous bit was 0 and current bit is 1
    assign pedge = (~prev_in) & current_in;

endmodule