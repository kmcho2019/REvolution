module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_state;
    reg  [511:0] next_state_reg;
    genvar i;

    // Compute next state combinationally from current q
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_logic
            wire left   = (i < 511) ? q[i+1] : 1'b0;
            wire center = q[i];
            wire right  = (i > 0) ? q[i-1] : 1'b0;
            // Rule 110 logic: next = (~left & center) | (center ^ right)
            assign next_state[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    // Pipeline register stage for next_state to break long combinational path
    always @(posedge clk) begin
        if (load) begin
            q <= data;             // Load input state directly
            next_state_reg <= 512'b0; // Optional: clear next_state_reg on load
        end else begin
            next_state_reg <= next_state;  // Register next state combinational output
            q <= next_state_reg;            // Update q from pipeline register stage
        end
    end

endmodule