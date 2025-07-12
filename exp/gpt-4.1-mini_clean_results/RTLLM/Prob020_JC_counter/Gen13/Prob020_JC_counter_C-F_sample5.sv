module JC_counter (
    input  wire       clk,    // Clock input
    input  wire       rst_n,  // Active-low asynchronous reset
    output reg [63:0] Q       // 64-bit Johnson counter output
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;              // Asynchronously reset counter to zero
    end else begin
        // On each clock, shift right by one and insert inverted LSB at MSB
        Q <= { ~Q[0], Q[63:1] };
    end
end

endmodule