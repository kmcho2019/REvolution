module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire rise,
    output wire down
);

    reg a_prev;  // Stores previous value of 'a'

    // Sequential logic: store previous value
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
        end else begin
            a_prev <= a;
        end
    end

    // Combinational logic: edge detection
    assign rise = ~a_prev & a;  // Rising edge: 0->1 transition
    assign down = a_prev & ~a;  // Falling edge: 1->0 transition

endmodule