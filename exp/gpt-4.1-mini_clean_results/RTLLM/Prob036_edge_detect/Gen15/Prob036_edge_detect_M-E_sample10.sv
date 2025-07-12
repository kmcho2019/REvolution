module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    // Two-stage shift register to delay 'a' over two clocks
    reg a_d1, a_d2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d1 <= 1'b0;
            a_d2 <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            a_d1 <= a;
            a_d2 <= a_d1;

            // Detect edges by comparing delayed samples:
            // If previous two samples were 0->1, rising edge detected at previous cycle.
            if ((a_d2 == 1'b0) && (a_d1 == 1'b1)) begin
                rise <= 1'b1;
            end else begin
                rise <= 1'b0;
            end

            // If previous two samples were 1->0, falling edge detected at previous cycle.
            if ((a_d2 == 1'b1) && (a_d1 == 1'b0)) begin
                down <= 1'b1;
            end else begin
                down <= 1'b0;
            end
        end
    end

endmodule