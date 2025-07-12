module TopModule (
    input wire clk,
    input wire reset,
    input wire [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] fall_edge_reg;

    // Register the previous input to detect edges
    always @(posedge clk) begin
        if (reset) begin
            prev_in <= in;  // Synchronize prev_in with input on reset
            fall_edge_reg <= 32'b0;
        end else begin
            // Detect falling edges: bits that were 1 and now 0
            fall_edge_reg <= prev_in & ~in;
            prev_in <= in;
        end
    end

    // Latch the falling edges until reset
    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
        end else begin
            out <= out | fall_edge_reg;
        end
    end

endmodule