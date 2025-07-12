module multi_booth_8bit (
    input  logic        clk,         // Clock signal
    input  logic        reset,       // Reset signal
    input  logic [7:0]  a,           // 8-bit multiplicand
    input  logic [7:0]  b,           // 8-bit multiplier
    output logic [15:0] p,           // 16-bit product
    output logic        rdy          // Ready signal
);

logic [15:0] multiplier;             // 16-bit multiplier register
logic [15:0] multiplicand;           // 16-bit multiplicand register
logic [4:0]  ctr;                    // 5-bit counter
logic [15:0] product;                // 16-bit product register

assign p = product;                  // Assign product to output

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize registers on reset
        multiplier <= {{8{a[7]}}, a};  // Sign-extend 'a'
        multiplicand <= {{8{b[7]}}, b}; // Sign-extend 'b'
        product <= 16'd0;               // Clear product
        ctr <= 5'd0;                    // Reset counter
        rdy <= 1'b0;                    // Reset ready signal
    end else begin
        if (ctr < 5'd16) begin
            // Perform Booth multiplication
            if (multiplier[ctr] == 1'b1) begin
                // Accumulate multiplicand into product
                product <= product + multiplicand;
            end
            // Left-shift multiplicand for next iteration
            multiplicand <= multiplicand << 1;
            // Increment counter
            ctr <= ctr + 5'd1;
        end else begin
            // Set ready signal when multiplication is complete
            rdy <= 1'b1;
        end
    end
end

endmodule