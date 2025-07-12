module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    // Register to hold previous value of 'a'
    reg a_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // Update delayed input
            a_d <= a;

            // Detect edges and set outputs accordingly
            if ((~a_d) & a)
                rise <= 1'b1;
            else
                rise <= 1'b0;

            if (a_d & (~a))
                down <= 1'b1;
            else
                down <= 1'b0;
        end
    end

endmodule