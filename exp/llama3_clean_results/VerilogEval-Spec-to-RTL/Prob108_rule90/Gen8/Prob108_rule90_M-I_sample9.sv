module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Combinational logic to calculate the next state of each cell
wire [511:0] next_state;

genvar i;
generate
    for (i = 0; i < 512; i++) begin
        wire left, center, right;
        // Boundary conditions
        if (i == 0) begin
            assign left = 0;
            assign center = q_reg[i];
            assign right = (i == 511) ? 0 : q_reg[i + 1];
        end else if (i == 511) begin
            assign left = q_reg[i - 1];
            assign center = q_reg[i];
            assign right = 0;
        end else begin
            assign left = q_reg[i - 1];
            assign center = q_reg[i];
            assign right = q_reg[i + 1];
        end
        // Apply Rule 90 logic
        assign next_state[i] = left ^ right; // No need to explicitly include center in XOR operation
    end
endgenerate

// Attempting to reduce switching activity by only updating q_reg when necessary
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else if (next_state != q_reg) begin // Update q_reg only if next_state differs
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule