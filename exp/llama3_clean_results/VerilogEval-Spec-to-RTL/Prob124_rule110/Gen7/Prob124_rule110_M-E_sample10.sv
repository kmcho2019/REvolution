module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

// Combinational logic to apply Rule 110
always @(*) begin
    for (int i = 0; i < 512; i++) begin
        reg left, center, right;
        reg [2:0] neighbor_values;
        
        // Handle boundary conditions
        if (i == 0) begin
            left = 1'b0;
        end else begin
            left = current_state[i-1];
        end
        if (i == 511) begin
            right = 1'b0;
        end else begin
            right = current_state[i+1];
        end
        center = current_state[i];

        // Pack neighbor values into a 3-bit value
        neighbor_values = {left, center, right};

        // Apply Rule 110
        case (neighbor_values)
            3'b000: next_state[i] = 1'b0;
            3'b001: next_state[i] = 1'b1;
            3'b010: next_state[i] = 1'b1;
            3'b011: next_state[i] = 1'b0;
            3'b100: next_state[i] = 1'b1;
            3'b101: next_state[i] = 1'b1;
            3'b110: next_state[i] = 1'b1;
            3'b111: next_state[i] = 1'b0;
            default: next_state[i] = 1'b0; // Should not occur
        endcase
    end
end

// Update current state on clock edge
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule