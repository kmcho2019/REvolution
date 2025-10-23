module JC_counter #(
    parameter WIDTH = 64
) (
    input clk,
    input rst_n,
    output reg [WIDTH-1:0] Q
);

// Johnson counter with parameterized width
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= {WIDTH{1'b0}};  // Async active-low reset
    end else begin
        Q <= {~Q[0], Q[WIDTH-1:1]};  // Shift right with inverted LSB as MSB
    end
end

endmodule