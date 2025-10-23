// TopModule: 4-bit shift register with asynchronous reset, synchronous load, and shift operations
module TopModule (
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]    q         // Output data
);

// Internal signal for shift operation result
wire [3:0] shift_result;

// Shift operation module
shift_register shift_reg (
    .in  (q),          // Input to shift register
    .out (shift_result) // Output of shift register
);

// Multiplexer for handling load and shift operations
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to zero
        q <= 4'b0;
    end else begin
        // Synchronous load and shift operations
        if (load) begin
            // Load data into shift register
            q <= data;
        end else if (ena) begin
            // Shift operation
            q <= shift_result;
        end
    end
end

// Shift register module
module shift_register (
    input   [3:0]    in,  // Input to shift register
    output  [3:0]    out  // Output of shift register
);
    assign out = {1'b0, in[3:1]};
endmodule

endmodule