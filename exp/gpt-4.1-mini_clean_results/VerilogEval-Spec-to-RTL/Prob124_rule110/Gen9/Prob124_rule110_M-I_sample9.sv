module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_state_reg;

    wire [511:0] next_state;
    genvar i;

    // Combinational logic to compute next_state from q
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_loop
            wire left   = (i == 511) ? 1'b0 : q[i+1];
            wire center = q[i];
            wire right  = (i == 0) ? 1'b0 : q[i-1];
            // Rule 110 logic: (~left & center) | (center ^ right)
            assign next_state[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    // Pipeline stage 1: register next_state output
    always @(posedge clk) begin
        next_state_reg <= next_state;
    end

    // Pipeline stage 2: update q from next_state_reg or load data
    // Add enable logic: update q only if load or next_state differs from q to reduce switching
    wire q_differs = (q != next_state_reg);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (q_differs) begin
            q <= next_state_reg;
        end
        // else hold q, reducing unnecessary toggling
    end

endmodule