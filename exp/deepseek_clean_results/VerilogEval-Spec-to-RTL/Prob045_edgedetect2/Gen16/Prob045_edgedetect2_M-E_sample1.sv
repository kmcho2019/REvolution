module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_state;

    always @(posedge clk) begin
        // Detect edges by comparing current and previous states
        anyedge <= (in != prev_state) ? 8'hFF : 8'h00;
        // Update state register
        prev_state <= in;
    end

endmodule