module JC_counter #(
    parameter WIDTH = 64
) (
    input clk,
    input rst_n,
    output reg [WIDTH-1:0] Q
);

// Terminal states for potential clock gating
wire all_zeros = (Q == {WIDTH{1'b0}});
wire all_ones = (Q == {WIDTH{1'b1}});

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= {WIDTH{1'b0}};  // Clear all bits on reset
    end else begin
        // Efficient shift operation with inverted LSB as new MSB
        Q <= {~Q[0], Q[WIDTH-1:1]};
        
        // Note: Clock gating could be added here using the terminal states
        // if (all_zeros || all_ones) disable clock;
    end
end

endmodule