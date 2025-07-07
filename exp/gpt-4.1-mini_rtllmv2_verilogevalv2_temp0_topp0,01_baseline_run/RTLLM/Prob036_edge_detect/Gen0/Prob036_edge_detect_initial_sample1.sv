module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d; // delayed version of a

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d  <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // Detect edges
            wire rising_edge  = (~a_d) & a;
            wire falling_edge = a_d & (~a);

            // Update delayed input
            a_d <= a;

            // Update rise output
            if (rising_edge)
                rise <= 1'b1;
            else if (falling_edge)
                rise <= rise; // hold until next rising edge
            else
                rise <= rise; // hold

            // Update down output
            if (falling_edge)
                down <= 1'b1;
            else if (rising_edge)
                down <= down; // hold until next falling edge
            else
                down <= down; // hold

            // Clear rise if a rising edge has not appeared and rise was previously set
            // Actually, per problem statement, rise and down remain set until the next corresponding edge appears.
            // So no clearing here except when the same edge appears again (which sets rise or down to 1 again).
            // So the outputs hold their values until the next edge of the same type.
        end
    end

endmodule