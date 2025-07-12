module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;
reg [511:0] next_state_reg; // Additional register for pipelining

// Combinational logic to calculate the next state of each cell
wire [511:0] next_state;

genvar i;
generate
    for (i = 0; i < 512; i++) begin
        wire left, right;
        // Explicit boundary conditions for clarity and potential synthesis optimization
        if (i == 0) begin
            assign left = 1'b0;
            assign right = (i == 511)? 1'b0 : q_reg[i + 1];
        end else if (i == 511) begin
            assign left = q_reg[i - 1];
            assign right = 1'b0;
        end else begin
            assign left = q_reg[i - 1];
            assign right = q_reg[i + 1];
        end
        // Apply Rule 90 logic directly without needing 'center'
        assign next_state[i] = left ^ right;
    end
endgenerate

// Pipelined sequential logic to update q_reg in two stages
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
        next_state_reg <= {512{1'b0}};
    end else begin
        // First stage: Calculate next state
        next_state_reg <= next_state;
        // Second stage: Update q_reg with calculated next state
        q_reg <= next_state_reg;
    end
end

assign q = q_reg;

endmodule