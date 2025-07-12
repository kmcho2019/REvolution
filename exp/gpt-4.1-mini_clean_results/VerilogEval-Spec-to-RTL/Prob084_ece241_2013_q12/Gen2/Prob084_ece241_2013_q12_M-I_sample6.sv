module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

    reg [7:0] Q;
    reg [2:0] addr_reg;

    // Shift register logic: shift left, MSB first (S into Q[0])
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // Register the address inputs to reduce glitches on output
    always @(posedge clk) begin
        addr_reg <= {A,B,C};
    end

    // Decode the registered address into one-hot signals
    wire [7:0] sel = 8'b00000001 << addr_reg;

    // Generate next Z combinationally from Q and sel
    wire z_next = |(Q & sel);

    // Register output Z for stable timing and glitch reduction
    always @(posedge clk) begin
        Z <= z_next;
    end

endmodule