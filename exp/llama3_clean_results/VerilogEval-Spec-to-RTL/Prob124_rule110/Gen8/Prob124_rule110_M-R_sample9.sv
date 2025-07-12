module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

// Sequential logic to update current state on the positive edge of the clock
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic to calculate next state
always @(*) begin
    next_state = 0;
    for (int i = 0; i < 512; i++) begin
        reg left, center, right;

        // Handle boundary conditions
        center = current_state[i];
        left = (i == 0) ? 1'b0 : current_state[i - 1];
        right = (i == 511) ? 1'b0 : current_state[i + 1];

        // Calculate next state based on Rule 110
        case ({left, center, right})
            3'b111: next_state[i] = 1'b0;
            3'b110: next_state[i] = 1'b1;
            3'b101: next_state[i] = 1'b1;
            3'b100: next_state[i] = 1'b0;
            3'b011: next_state[i] = 1'b1;
            3'b010: next_state[i] = 1'b1;
            3'b001: next_state[i] = 1'b1;
            3'b000: next_state[i] = 1'b0;
        endcase
    end
end

// Output current state
assign q = current_state;

endmodule