module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 1'b0;
            rise  <= 1'b0;
            down  <= 1'b0;
        end else begin
            // Store previous a
            a_reg <= a;

            // Detect rising edge: previous 0, current 1
            if (~a_reg & a)
                rise <= 1'b1;
            else if (rise) // Hold rise until next rising edge resets it
                rise <= rise;

            // Detect falling edge: previous 1, current 0
            if (a_reg & ~a)
                down <= 1'b1;
            else if (down) // Hold down until next falling edge resets it
                down <= down;

            // Reset rise if another rising edge not detected
            if (rise && (~(~a_reg & a)))
                rise <= rise;

            // Reset down if another falling edge not detected
            if (down && (~(a_reg & ~a)))
                down <= down;
        end
    end

endmodule