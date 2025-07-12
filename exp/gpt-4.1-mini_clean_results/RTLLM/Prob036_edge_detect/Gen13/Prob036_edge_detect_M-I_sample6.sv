module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d;

    // Register previous value of 'a'
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_d <= 1'b0;
        else
            a_d <= a;
    end

    // Register outputs, set to 1 on next clock after detecting edges, then back to 0
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= (~a_d & a);
            down <= (a_d & ~a);
        end
    end

endmodule