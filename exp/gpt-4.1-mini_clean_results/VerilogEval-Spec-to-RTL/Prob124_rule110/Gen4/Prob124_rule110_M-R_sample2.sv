module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

    // Rule 110 truth table encoded as an 8-bit constant
    // Index = {left, center, right}, with left as MSB
    // 111:0, 110:1, 101:1, 100:0, 011:1, 010:1, 001:1, 000:0
    localparam [7:0] RULE110 = 8'b01101110;

    reg [511:0] state;       // current state register
    reg [511:0] next_state;  // combinational next state

    integer i;
    always @* begin
        for (i = 0; i < 512; i = i + 1) begin
            // Determine neighbors with zero boundary conditions
            wire left = (i == 511) ? 1'b0 : state[i+1];
            wire center = state[i];
            wire right = (i == 0) ? 1'b0 : state[i-1];

            // Form 3-bit pattern
            wire [2:0] pattern = {left, center, right};

            // Next state from Rule 110 lookup
            next_state[i] = RULE110[pattern];
        end
    end

    // Output is driven directly from current state
    assign q = state;

    // Sequential state update with synchronous load
    always @(posedge clk) begin
        if (load)
            state <= data;
        else
            state <= next_state;
    end

endmodule