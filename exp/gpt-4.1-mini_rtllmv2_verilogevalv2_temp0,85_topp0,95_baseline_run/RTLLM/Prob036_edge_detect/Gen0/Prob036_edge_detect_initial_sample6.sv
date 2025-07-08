module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d  <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // Detect rising edge
            if (~a_d & a) begin
                rise <= 1'b1;
                down <= down; // keep previous down value
            end
            // Detect falling edge
            else if (a_d & ~a) begin
                down <= 1'b1;
                rise <= rise; // keep previous rise value
            end
            // No edge detected
            else begin
                // Maintain outputs until the same edge occurs again
                rise <= rise;
                down <= down;
            end

            a_d <= a;
        end
    end

endmodule