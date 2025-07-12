module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // Each bit has [previous_state, current_state]
    reg [1:0] bit_state [7:0];

    integer i;

    always @(posedge clk) begin
        // State update
        for (i = 0; i < 8; i = i + 1) begin
            bit_state[i][1] <= bit_state[i][0];  // previous becomes older
            bit_state[i][0] <= in[i];           // current becomes new input
        end

        // Edge detection
        for (i = 0; i < 8; i = i + 1) begin
            anyedge[i] <= (bit_state[i][0] != bit_state[i][1]);
        end
    end

endmodule