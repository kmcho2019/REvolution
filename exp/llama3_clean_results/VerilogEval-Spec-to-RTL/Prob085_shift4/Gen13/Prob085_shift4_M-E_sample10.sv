// TopModule: 4-bit shift register with asynchronous reset, synchronous load, and shift operations
module TopModule (
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]    q         // Output data
);

// 4-bit register file
reg [3:0] q_reg;

// Multiplexers to select input data or current register value
wire [3:0] mux_out;

always @(*) begin
    if (load) begin
        // Load input data
        mux_out = data;
    end else if (ena) begin
        // Shift current register value to the right
        mux_out = {1'b0, q_reg[3:1]};
    end else begin
        // Hold current register value
        mux_out = q_reg;
    end
end

// Registers to store current state of shift register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to zero
        q_reg <= 4'b0;
    end else begin
        q_reg <= mux_out;
    end
end

// Assign output
assign q = q_reg;

endmodule