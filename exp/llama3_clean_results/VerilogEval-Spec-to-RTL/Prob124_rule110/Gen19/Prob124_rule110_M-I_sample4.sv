module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;

// Combinational logic to compute the next state
reg [511:0] next_state;
always @(*) begin
    for (int i = 0; i < 512; i++) begin
        reg left, center, right;
        
        // Determine the states of the neighbors, considering boundary conditions
        left = (i == 0) ? 1'b0 : current_state[i - 1];
        center = current_state[i];
        right = (i == 511) ? 1'b0 : current_state[i + 1];
        
        // Use a case statement to determine the next state according to Rule 110
        case ({left, center, right})
            3'b000: next_state[i] = 1'b0;
            3'b001: next_state[i] = 1'b1;
            3'b010: next_state[i] = 1'b1;
            3'b011: next_state[i] = 1'b1;
            3'b100: next_state[i] = 1'b0;
            3'b101: next_state[i] = 1'b1;
            3'b110: next_state[i] = 1'b1;
            3'b111: next_state[i] = 1'b0;
            default: next_state[i] = 1'b0; // Default case for completeness
        endcase
    end
end

// Sequential logic to update the current state
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule