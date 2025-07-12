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

            if (~a_prev & a) begin
                // Rising edge detected
                rise <= 1'b1;
                down <= 1'b0;
            end else if (a_prev & ~a) begin
                // Falling edge detected
                down <= 1'b1;
                rise <= 1'b0;
            end
            // else retain previous rise/down state
        end
    end

endmodule