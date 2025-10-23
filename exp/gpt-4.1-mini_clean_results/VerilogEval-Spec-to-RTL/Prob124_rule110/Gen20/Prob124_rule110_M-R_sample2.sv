module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Extended state with zero boundaries on both ends for neighbor access
    wire [513:0] ext_state = {1'b0, q, 1'b0};

    // Next state combinational signal
    wire [511:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_logic
            wire left   = ext_state[i+2];
            wire center = ext_state[i+1];
            wire right  = ext_state[i];

            // Implement Rule 110 truth table explicitly:
            // next = 0 when neighborhood is 111, 100, or 000
            // next = 1 otherwise
            assign next_state[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    // State register update on positive clock edge
    // Load takes priority over next state update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule