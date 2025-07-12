module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;

    always @(posedge clk) begin
        prev_in <= in;                  // Store current input for next cycle
    end

    always @(posedge clk) begin
        anyedge <= in ^ prev_in;        // XOR current and previous input; register output
    end
endmodule