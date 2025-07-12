module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Register to store the current state

// Combinational logic to compute the next state
wire [511:0] next_state;
genvar i;
generate
    for (i = 0; i < 512; i++) begin
        // Apply Rule 90 logic directly
        if (i == 0) begin
            assign next_state[i] = (i == 0) ? (1'b0 ^ q_reg[i + 1]) : (q_reg[i - 1] ^ q_reg[i + 1]);
        end else if (i == 511) begin
            assign next_state[i] = q_reg[i - 1] ^ 1'b0;
        end else begin
            assign next_state[i] = q_reg[i - 1] ^ q_reg[i + 1];
        end
    end
endgenerate

// Update q_reg based on load and calculated next states
always @(posedge clk) begin
    if (load) begin
        q_reg <= data; // Load input data
    end else begin
        q_reg <= next_state; // Update with calculated next states
    end
end

assign q = q_reg; // Output the current state

endmodule