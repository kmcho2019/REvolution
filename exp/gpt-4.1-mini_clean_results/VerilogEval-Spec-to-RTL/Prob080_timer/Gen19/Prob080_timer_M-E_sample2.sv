module TopModule(
    input        clk,
    input        load,
    input [9:0]  data,
    output       tc
);

    // Using a 10-bit shift register to implement countdown timer in thermometer code:
    // On load, load a pattern with 'data' number of ones starting from MSB, followed by zeros.
    // On each clock cycle (if load=0), shift right by 1 bit (countdown).
    // The terminal count (tc) is asserted when the MSB is zero (no bits left set).

    reg [9:0] shift_reg;

    // Generate thermometer pattern: left 'data' bits are ones, rest zeros
    wire [9:0] load_pattern = {10{1'b1}} >> (10 - data);

    always @(posedge clk) begin
        if (load) begin
            // Load thermometer pattern representing countdown value
            shift_reg <= load_pattern;
        end else begin
            // Shift right by one to count down if not zero
            if (shift_reg != 0)
                shift_reg <= {1'b0, shift_reg[9:1]};
            else
                shift_reg <= shift_reg; // Hold zero state
        end
    end

    // Terminal count asserted when shift_reg MSB == 0 (no ones left)
    assign tc = (shift_reg == 0);

endmodule