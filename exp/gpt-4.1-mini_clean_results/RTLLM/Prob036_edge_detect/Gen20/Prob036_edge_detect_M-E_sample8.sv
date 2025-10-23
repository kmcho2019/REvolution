module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    // Two-stage shift register for input 'a'
    reg a_d1, a_d2;

    always @(posedge clk) begin
        if (!rst_n) begin
            a_d1 <= 1'b0;
            a_d2 <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            a_d1 <= a;
            a_d2 <= a_d1;

            // Default clear outputs (one-clock pulse)
            rise <= 1'b0;
            down <= 1'b0;

            // Edge detection comparing delayed samples
            if ((a_d1 == 1'b1) && (a_d2 == 1'b0))
                rise <= 1'b1;   // rising edge detected at previous cycle
            else if ((a_d1 == 1'b0) && (a_d2 == 1'b1))
                down <= 1'b1;   // falling edge detected at previous cycle
        end
    end

endmodule