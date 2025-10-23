module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    // Register the previous input at each clock
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Compute pedge based on stored previous input and current input
    always @(posedge clk) begin
        pedge <= (~prev_in) & in;
    end

endmodule