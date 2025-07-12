module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire rise,
    output wire down
);

    reg a_prev;  // Stores the previous value of 'a'
    wire a_changed = (a != a_prev);  // Only update when input changes

    // Sequential part: store previous value only when needed
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
        end
        else if (a_changed) begin
            a_prev <= a;
        end
    end

    // Combinational part: edge detection (unchanged)
    assign rise = a & ~a_prev;  // Rising edge detection
    assign down = ~a & a_prev;  // Falling edge detection

endmodule