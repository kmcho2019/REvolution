module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

// Combinatorial logic to calculate the next state
always @(*) begin
    for (int i = 0; i < 512; i++) begin
        reg left, center, right;
        // Handle edge cases
        if (i == 0) begin
            left = 1'b0;
            center = current_state[i];
            right = current_state[i + 1];
        end else if (i == 511) begin
            left = current_state[i - 1];
            center = current_state[i];
            right = 1'b0;
        end else begin
            left = current_state[i - 1];
            center = current_state[i];
            right = current_state[i + 1];
        end
        
        // Apply Rule 110
        case ({left, center, right})
            3'b111: next_state[i] = 1'b0;
            3'b110: next_state[i] = 1'b1;
            3'b101: next_state[i] = 1'b1;
            3'b100: next_state[i] = 1'b0;
            3'b011: next_state[i] = 1'b1;
            3'b010: next_state[i] = 1'b1;
            3'b001: next_state[i] = 1'b1;
            3'b000: next_state[i] = 1'b0;
            default: next_state[i] = 1'bx;
        endcase
    end
end

// Sequential logic to update the state
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

// Drive the output
assign q = current_state;

endmodule