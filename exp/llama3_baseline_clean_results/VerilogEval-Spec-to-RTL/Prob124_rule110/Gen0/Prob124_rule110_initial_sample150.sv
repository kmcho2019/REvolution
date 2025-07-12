module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Current state of the system
reg [511:0] q_next; // Next state of the system

// Initialize the output with the current state
assign q = q_reg;

// Compute the next state of each cell on each clock cycle
always @(*) begin
    for (int i = 0; i < 512; i++) begin
        // Handle boundaries
        reg left, center, right;
        if (i == 0) begin
            left = 0;
            center = q_reg[i];
            right = q_reg[i + 1];
        end else if (i == 511) begin
            left = q_reg[i - 1];
            center = q_reg[i];
            right = 0;
        end else begin
            left = q_reg[i - 1];
            center = q_reg[i];
            right = q_reg[i + 1];
        end

        // Implement the Rule 110 table
        case ({left, center, right})
            3'b111: q_next[i] = 0;
            3'b110: q_next[i] = 1;
            3'b101: q_next[i] = 1;
            3'b100: q_next[i] = 0;
            3'b011: q_next[i] = 1;
            3'b010: q_next[i] = 1;
            3'b001: q_next[i] = 1;
            3'b000: q_next[i] = 0;
            default: q_next[i] = 0;
        endcase
    end
end

// Update the state of the system on the positive edge of the clock
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= q_next;
    end
end

endmodule