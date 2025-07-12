module JC_counter #(
    parameter WIDTH = 64
) (
    input  wire              clk,    // Clock signal for synchronous operation
    input  wire              rst_n,  // Asynchronous active-low reset
    output reg  [WIDTH-1:0]  Q       // Johnson counter output
);

// Invert LSB to generate new MSB
wire new_msb = ~Q[0];

// Sequential logic with asynchronous reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= {WIDTH{1'b0}};       // Reset to zero
    end else begin
        Q <= {new_msb, Q[WIDTH-1:1]}; // Shift right and insert inverted LSB as new MSB
    end
end

endmodule