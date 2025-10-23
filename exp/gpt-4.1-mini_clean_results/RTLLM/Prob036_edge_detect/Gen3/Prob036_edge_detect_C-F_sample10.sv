module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d;  // delayed version of input 'a'

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d  <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // Default outputs to 0 each cycle
            rise <= 1'b0;
            down <= 1'b0;

            // Detect edges based on previous sampled input a_d and current a
            if (~a_d & a)       // rising edge detected
                rise <= 1'b1;
            else if (a_d & ~a)  // falling edge detected
                down <= 1'b1;

            // Update delayed input
            a_d <= a;
        end
    end

endmodule