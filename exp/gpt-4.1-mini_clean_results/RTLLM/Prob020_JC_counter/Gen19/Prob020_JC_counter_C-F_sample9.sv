module JC_counter (
    input  wire       clk,    // Clock signal for synchronous operation
    input  wire       rst_n,  // Asynchronous active-low reset
    output reg [63:0] Q       // 64-bit Johnson counter output
);

// Wire holding inverted LSB to improve clarity and synthesis
wire new_msb = ~Q[0];

// Sequential logic with asynchronous reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;                // Asynchronously reset counter to zero
    end else begin
        // Shift right by 1 and insert inverted LSB at MSB
        Q <= {new_msb, Q[63:1]};
    end
end

endmodule