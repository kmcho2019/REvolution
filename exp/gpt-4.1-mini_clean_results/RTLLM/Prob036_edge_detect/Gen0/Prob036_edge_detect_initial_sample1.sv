module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d;  // delayed version of 'a'

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d  <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // Detect edges by comparing current and delayed 'a'
            if (~a_d & a)       // Rising edge detected
                rise <= 1'b1;
            else
                rise <= rise;  // Hold until next rising edge

            if (a_d & ~a)       // Falling edge detected
                down <= 1'b1;
            else
                down <= down;  // Hold until next falling edge

            a_d <= a;  // Update delayed 'a'
        end
    end

endmodule