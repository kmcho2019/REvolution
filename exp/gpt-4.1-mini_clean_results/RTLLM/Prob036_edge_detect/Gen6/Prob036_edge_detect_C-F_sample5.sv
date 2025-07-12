module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_prev;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
            rise   <= 1'b0;
            down   <= 1'b0;
        end else begin
            // Detect edges based on previous and current 'a'
            rise <= (~a_prev) & a;    // rising edge: 0->1
            down <= a_prev & (~a);    // falling edge: 1->0
            a_prev <= a;
        end
    end

endmodule