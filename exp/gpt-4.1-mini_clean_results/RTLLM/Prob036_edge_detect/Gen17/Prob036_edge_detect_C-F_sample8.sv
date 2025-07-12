module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_reg;
    wire rising_edge;
    wire falling_edge;

    // Register the previous value of 'a'
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_reg <= 1'b0;
        else
            a_reg <= a;
    end

    // Detect edges combinationally
    assign rising_edge  = (~a_reg) & a;
    assign falling_edge = a_reg & (~a);

    // Register outputs 'rise' and 'down', hold until next edge clears or toggles them
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // On rising edge, set rise=1 and clear down
            if (rising_edge) begin
                rise <= 1'b1;
                down <= 1'b0;
            end
            // On falling edge, set down=1 and clear rise
            else if (falling_edge) begin
                down <= 1'b1;
                rise <= 1'b0;
            end
            // Otherwise hold previous values
            else begin
                rise <= rise;
                down <= down;
            end
        end
    end

endmodule