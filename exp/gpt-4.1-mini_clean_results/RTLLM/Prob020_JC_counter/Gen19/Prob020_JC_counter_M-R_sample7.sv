module JC_counter (
    input  wire       clk,    // Clock signal for synchronous operation
    input  wire       rst_n,  // Asynchronous active-low reset
    output reg [63:0] Q       // 64-bit Johnson counter output
);

    reg [63:0] next_Q;

    // Combinational logic to determine the next state of the Johnson counter
    always @(*) begin
        // Insert the inverted LSB of Q at MSB, and shift Q right by one bit
        next_Q = {~Q[0], Q[63:1]};
    end

    // Sequential logic updates Q on rising clock or asynchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q <= 64'b0;      // Reset counter to zero asynchronously
        end else begin
            Q <= next_Q;     // Update counter with next state
        end
    end

endmodule