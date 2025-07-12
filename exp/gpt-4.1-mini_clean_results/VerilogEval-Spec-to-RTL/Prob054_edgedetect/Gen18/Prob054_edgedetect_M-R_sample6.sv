module TopModule (
    input             clk,
    input      [7:0]  in,
    output reg [7:0]  pedge
);

    reg [7:0] curr_in;

    // Register current input at clock edge
    always @(posedge clk) begin
        curr_in <= in;
    end

    // Detect positive edges by comparing current and registered input, register output
    always @(posedge clk) begin
        pedge <= (~in) & curr_in;
    end

endmodule