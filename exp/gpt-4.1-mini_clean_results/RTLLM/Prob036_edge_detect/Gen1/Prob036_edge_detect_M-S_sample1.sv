module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d;       // previous value of a
    reg rise_latch;
    reg down_latch;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d        <= 1'b0;
            rise_latch <= 1'b0;
            down_latch <= 1'b0;
            rise       <= 1'b0;
            down       <= 1'b0;
        end else begin
            a_d <= a;

            // Detect edges
            if (~a_d & a)       // rising edge
                rise_latch <= ~rise_latch;
            if (a_d & ~a)       // falling edge
                down_latch <= ~down_latch;

            rise <= rise_latch;
            down <= down_latch;
        end
    end

endmodule