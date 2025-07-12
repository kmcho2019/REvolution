module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // Individual bit history registers
    reg [7:0] prev_state;

    // Generate edge detectors for each bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_monitors
            always @(posedge clk) begin
                // Store previous state
                prev_state[i] <= in[i];
                
                // Detect any transition (0->1 or 1->0)
                anyedge[i] <= (in[i] ^ prev_state[i]);
            end
        end
    endgenerate

endmodule