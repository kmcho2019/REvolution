module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    reg a_prev;  // Stores the previous value of 'a'

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end
        else begin
            a_prev <= a;  // Update the previous value of 'a'
            
            // Detect rising edge (0->1 transition)
            if (a && !a_prev) begin
                rise <= 1'b1;
            end
            else begin
                rise <= 1'b0;
            end
            
            // Detect falling edge (1->0 transition)
            if (!a && a_prev) begin
                down <= 1'b1;
            end
            else begin
                down <= 1'b0;
            end
        end
    end

endmodule