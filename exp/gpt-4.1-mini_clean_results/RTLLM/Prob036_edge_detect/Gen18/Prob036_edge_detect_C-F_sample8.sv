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
            // Detect edges by comparing current a and previous a
            rise <= (~a_prev) & a;  // rising edge: a changed from 0 to 1
            down <= a_prev & (~a);  // falling edge: a changed from 1 to 0

            a_prev <= a;
        end
    end

endmodule