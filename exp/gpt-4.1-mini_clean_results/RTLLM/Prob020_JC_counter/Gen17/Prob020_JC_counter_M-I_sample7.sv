module JC_counter (
    input  wire       clk,    // Clock signal for synchronous operation
    input  wire       rst_n,  // Asynchronous active-low reset
    output reg [63:0] Q       // 64-bit Johnson counter output
);

// On the rising edge of clk or falling edge of rst_n, update the Johnson counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;               // Reset counter to zero asynchronously
    end else begin
        // Shift right by 1 bit and insert the inverted LSB at MSB position
        Q <= {~Q[0], Q[63:1]};
    end
end

endmodule