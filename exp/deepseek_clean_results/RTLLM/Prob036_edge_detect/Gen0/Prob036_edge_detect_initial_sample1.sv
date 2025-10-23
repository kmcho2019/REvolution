module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_prev;  // Stores the previous value of 'a'

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
            rise   <= 1'b0;
            down   <= 1'b0;
        end
        else begin
            a_prev <= a;  // Update the stored value

            // Detect rising edge (0->1 transition)
            rise <= (a & ~a_prev);

            // Detect falling edge (1->0 transition)
            down <= (~a & a_prev);
        end
    end

endmodule