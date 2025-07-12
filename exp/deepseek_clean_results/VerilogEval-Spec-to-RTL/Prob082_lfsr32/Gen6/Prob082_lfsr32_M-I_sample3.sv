module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

reg feedback_reg;  // Registered feedback term for timing
wire feedback = q[0];
wire [31:0] next_q;

// Clock gating for upper bits (31:23) that don't need XOR
wire upper_bits_clk = clk & (~reset) & (|q[22:0]);

// Combined XOR for bits 2 and 1
wire [1:0] lower_bits = {q[2], q[1]} ^ {2{feedback}};

always @(posedge clk) begin
    feedback_reg <= feedback;
    
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        // Registered Galois LFSR with optimized taps
        q <= {feedback_reg, 
              q[31:23], 
              q[22] ^ feedback_reg, 
              q[21:3], 
              lower_bits};
    end
end

// Clock gating implementation for upper bits
always @(posedge upper_bits_clk or posedge reset) begin
    if (reset) begin
        q[31:23] <= 0;
    end
    else begin
        q[31:23] <= q[31:23];
    end
end

endmodule