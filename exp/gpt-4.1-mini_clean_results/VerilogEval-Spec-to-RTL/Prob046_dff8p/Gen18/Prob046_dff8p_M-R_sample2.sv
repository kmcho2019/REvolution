module DFF_negclk_sync_reset (
    input  wire clk,
    input  wire reset,
    input  wire d,
    output reg  q
);
    // Negative edge triggered DFF with synchronous active-high reset
    always @(negedge clk) begin
        if (reset) begin
            q <= 1'b0;  // default bit reset, overwritten later in vector
        end else begin
            q <= d;
        end
    end
endmodule

module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output [7:0] q
);
    wire [7:0] reset_pattern = 8'h34;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_array
            // Instantiate one bit DFF with synchronous reset logic
            // Override reset output based on reset pattern bit
            reg q_reg;
            always @(negedge clk) begin
                if (reset)
                    q_reg <= reset_pattern[i];
                else
                    q_reg <= d[i];
            end
            assign q[i] = q_reg;
        end
    endgenerate

endmodule