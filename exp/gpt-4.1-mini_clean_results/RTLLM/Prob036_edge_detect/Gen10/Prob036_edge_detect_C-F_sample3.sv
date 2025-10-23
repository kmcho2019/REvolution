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
            // Store previous state of 'a'
            a_prev <= a;

            // Detect rising edge: previous 0, current 1
            if (~a_prev & a)
                rise <= 1'b1;
            else
                rise <= 1'b0;

            // Detect falling edge: previous 1, current 0
            if (a_prev & ~a)
                down <= 1'b1;
            else
                down <= 1'b0;
        end
    end

endmodule