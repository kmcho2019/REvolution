module edge_detect (
    input wire clk,
    input wire rst_n,
    input wire a,
    output reg rise,
    output reg down
);

    reg a_d;  // delayed version of a

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // Detect rising edge: previous a=0 and current a=1
            if (a == 1'b1 && a_d == 1'b0)
                rise <= 1'b1;
            else
                rise <= 1'b0;

            // Detect falling edge: previous a=1 and current a=0
            if (a == 1'b0 && a_d == 1'b1)
                down <= 1'b1;
            else
                down <= 1'b0;

            a_d <= a;
        end
    end

endmodule