module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_prev;

    // On each clock, sample input and detect edges by comparing with previous sample
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
            rise   <= 1'b0;
            down   <= 1'b0;
        end else begin
            // Detect rising edge: previous=0, current=1
            rise <= (~a_prev) & a;

            // Detect falling edge: previous=1, current=0
            down <= a_prev & (~a);

            // Update previous value
            a_prev <= a;
        end
    end

endmodule