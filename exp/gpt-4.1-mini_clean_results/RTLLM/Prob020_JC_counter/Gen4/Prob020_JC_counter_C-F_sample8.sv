module JC_counter #(
    parameter WIDTH = 64
)(
    input  wire             clk,
    input  wire             rst_n,
    output reg [WIDTH-1:0]  Q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= {WIDTH{1'b0}};  // Reset counter to zero
    end else begin
        // Johnson counter update:
        // Shift right by 1 bit; insert complement of LSB at MSB
        Q <= {~Q[0], Q[WIDTH-1:1]};
    end
end

endmodule