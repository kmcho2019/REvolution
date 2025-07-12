module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d;  // delayed version of a

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d  <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // default clear outputs each cycle
            rise <= 1'b0;
            down <= 1'b0;

            // detect edges based on delayed signal
            if (~a_d & a)       // rising edge
                rise <= 1'b1;
            else if (a_d & ~a)  // falling edge
                down <= 1'b1;

            // update delayed signal
            a_d <= a;
        end
    end

endmodule