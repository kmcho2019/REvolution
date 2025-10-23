module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_dly1, a_dly2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_dly1 <= 1'b0;
            a_dly2 <= 1'b0;
            rise   <= 1'b0;
            down   <= 1'b0;
        end else begin
            // Shift input into two-stage shift register
            a_dly1 <= a;
            a_dly2 <= a_dly1;

            // Detect edges by comparing two delayed versions
            if (a_dly1 & ~a_dly2) begin
                // Rising edge detected: set rise high, clear down
                rise <= 1'b1;
                down <= 1'b0;
            end else if (~a_dly1 & a_dly2) begin
                // Falling edge detected: set down high, clear rise
                rise <= 1'b0;
                down <= 1'b1;
            end
            // Else keep previous values of rise and down (hold)
        end
    end

endmodule