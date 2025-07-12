module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // 2-bit state for each input: [1] = previous value, [0] = current value
    reg [1:0] state [7:0];

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Update state machine
            state[i] <= {state[i][0], in[i]};
            
            // Detect any edge (state transition where bits differ)
            anyedge[i] <= (state[i][1] ^ state[i][0]);
        end
    end

endmodule