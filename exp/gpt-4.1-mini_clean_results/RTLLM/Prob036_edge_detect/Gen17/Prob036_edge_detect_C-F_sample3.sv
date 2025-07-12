module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d  <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // Edge detection logic using previous 'a' stored in a_d
            rise <= (~a_d) & a;  // rising edge detected at this clock
            down <= a_d & (~a);  // falling edge detected at this clock

            a_d <= a;            // update stored previous value of 'a'
        end
    end

endmodule