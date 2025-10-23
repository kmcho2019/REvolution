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
            a_prev <= a;

            // Detect rising edge
            if ((~a_prev) & a)
                rise <= 1'b1;

            // Detect falling edge
            if (a_prev & (~a))
                down <= 1'b1;

            // Clear rise when falling edge detected
            if (a_prev & (~a))
                rise <= 1'b0;

            // Clear down when rising edge detected
            if ((~a_prev) & a)
                down <= 1'b0;
        end
    end

endmodule