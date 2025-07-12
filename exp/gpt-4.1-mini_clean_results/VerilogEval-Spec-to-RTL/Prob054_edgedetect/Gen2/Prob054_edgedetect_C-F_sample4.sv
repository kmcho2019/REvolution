module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] detected;

    // Register previous input vector on each clock cycle
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational detection of 0-to-1 transitions per bit
    assign detected = (~prev_in) & in;

    // Register detection result to produce output pedge delayed by one cycle
    always @(posedge clk) begin
        pedge <= detected;
    end

endmodule