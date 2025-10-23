module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Combinational next-state logic
wire [63:0] next_Q = {~Q[0], Q[63:1]};

// Sequential state storage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Active-low reset
    end
    else begin
        Q <= next_Q;  // Update with combinational logic result
    end
end

endmodule