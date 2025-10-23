module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d;

    // Register previous state of 'a'
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_d <= 1'b0;
        else
            a_d <= a;
    end

    // Generate 1-clock-cycle pulse for rise and down
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            if (~a_d & a)
                rise <= 1'b1;
            else
                rise <= 1'b0;

            if (a_d & ~a)
                down <= 1'b1;
            else
                down <= 1'b0;
        end
    end

endmodule