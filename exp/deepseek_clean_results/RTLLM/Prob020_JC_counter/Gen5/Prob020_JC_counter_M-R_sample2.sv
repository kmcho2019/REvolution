module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Combinational logic for next state
wire [63:0] next_Q = {~Q[0], Q[63:1]};

// Sequential logic with synchronous reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Active-low reset clears all bits
    end else begin
        Q <= next_Q;  // Update state with combinational logic result
    end
end

endmodule