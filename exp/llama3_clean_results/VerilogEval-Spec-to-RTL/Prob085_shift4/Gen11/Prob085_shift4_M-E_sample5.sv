module TopModule (
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]   data,     // Input data
    output  [3:0]   q         // Output data
);

// 4-bit shift register
reg [3:0] q_reg;

// Shift logic
wire [3:0] shift_out;
assign shift_out = {1'b0, q_reg[3:1]};

// Data MUX: Selects between input data and shifted register value
wire [3:0] data_mux_out;
assign data_mux_out = load ? data : shift_out;

// Enable MUX: Determines whether to update the register
wire [3:0] enable_mux_out;
assign enable_mux_out = (load || ena) ? data_mux_out : q_reg;

// Asynchronous reset, synchronous load and shift operations
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to zero
        q_reg <= 4'b0;
    end else begin
        // Synchronous update of the register
        q_reg <= enable_mux_out;
    end
end

// Assign output
assign q = q_reg;

endmodule