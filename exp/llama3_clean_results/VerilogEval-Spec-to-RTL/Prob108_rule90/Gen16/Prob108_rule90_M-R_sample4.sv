module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Calculate the next state directly using Rule 90 and XOR properties
wire [511:0] next_state;
assign next_state = (q_reg << 1) ^ (q_reg >> 1);

// Sequential logic to update q_reg on the positive edge of the clock
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule