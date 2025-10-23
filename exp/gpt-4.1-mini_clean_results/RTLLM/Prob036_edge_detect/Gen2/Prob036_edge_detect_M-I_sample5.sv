module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d; // delayed version of 'a'

    // Combined always block with synchronous active-low reset
    always @(posedge clk) begin
        if (!rst_n) begin
            a_d   <= 1'b0;
            rise  <= 1'b0;
            down  <= 1'b0;
        end else begin
            // Register delayed input
            a_d <= a;

            // Detect edges and generate one-cycle pulse outputs
            rise <= (~a_d) & a;
            down <= a_d & (~a);
        end
    end

endmodule