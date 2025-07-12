module counter_12(
    input logic rst_n,
    input logic clk,
    input logic valid_count,
    output logic [3:0] out
);

logic [3:0] next_out;

// Combinational logic to calculate the next state
always_comb begin
    if (out == 4'd11 && valid_count) begin
        next_out = 4'b0000;  // Wrap around to 0 when count reaches maximum
    end else if (valid_count) begin
        next_out = out + 1;  // Increment counter by 1
    end else begin
        next_out = out;  // Keep the current count value when valid_count is 0
    end
end

// Sequential logic for state update
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;  // Reset counter to 0 when rst_n is 0
    end else begin
        out <= next_out;  // Update the output register with the calculated next state
    end
end

endmodule