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
        // Apply Rule 90 logic using XOR, handling boundary conditions directly
        assign next_state[i] = (i == 0) ? q_reg[0] ^ q_reg[1] : 
                               (i == 511) ? q_reg[510] ^ q_reg[511] : 
                               q_reg[i-1] ^ q_reg[i+1];
    end
endgenerate

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