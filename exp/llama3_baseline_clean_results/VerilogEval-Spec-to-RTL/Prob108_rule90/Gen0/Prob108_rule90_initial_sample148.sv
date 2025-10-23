module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // register to store the current state

// Initialize the output
assign q = q_reg;

// Update the register on the positive edge of the clock
always @(posedge clk) begin
    if (load) begin
        // Load the register with the data input
        q_reg <= data;
    end else begin
        // Update the register according to the Rule 90 rules
        q_reg <= {
            q_reg[1], // q[0] = q[1] XOR 0
            {509{q_reg[$-2:0] ^ q_reg[$-1:1]}}, // q[1:510] = q[0:509] XOR q[2:511]
            q_reg[510] // q[511] = q[510] XOR 0
        };
    end
end

endmodule