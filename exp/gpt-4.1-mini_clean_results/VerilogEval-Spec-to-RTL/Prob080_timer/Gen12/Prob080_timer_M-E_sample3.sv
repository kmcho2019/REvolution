module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_reg;
    wire [9:0] load_pattern;
    integer i;

    // Generate one-hot load pattern: set bit at (data-1) if data > 0, else 0
    // If data == 0, shift_reg is loaded with 0 (timer immediately expired)
    // Using combinational logic for the load pattern
    always @(*) begin
        load_pattern = 10'b0;
        if (data != 0) begin
            // Safety check: data can be 1 to 10
            // Position = data-1, but clamp if >9
            // data can be max 10, so bit 9 corresponds to data=10
            // Ensure only one bit set at position data-1
            load_pattern = 10'b0;
            load_pattern[data-1] = 1'b1;
        end
    end

    // Shift register update at positive clock edge
    always @(posedge clk) begin
        if (load) begin
            shift_reg <= load_pattern;
        end else begin
            // Shift right by 1, inserting 0 at MSB; if shift_reg is zero remain zero
            shift_reg <= (shift_reg != 0) ? (shift_reg >> 1) : shift_reg;
        end
    end

    // Terminal count when LSB of shift register is 1 (timer expired)
    assign tc = shift_reg[0];

endmodule