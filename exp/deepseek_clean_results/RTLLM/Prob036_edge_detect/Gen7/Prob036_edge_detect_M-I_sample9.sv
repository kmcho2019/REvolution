module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire rise,
    output wire down
);

    reg a_prev;  // Stores previous value of 'a'
    wire a_changed;  // Indicates when 'a' changes
    wire clk_en;  // Clock enable signal

    // Clock gating logic - only update when 'a' changes
    assign a_changed = a ^ a_prev;
    assign clk_en = a_changed;

    // Sequential logic with clock gating
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
        end else if (clk_en) begin
            a_prev <= a;
        end
    end

    // Shared inverter logic for edge detection
    wire a_inv;
    assign a_inv = ~a;
    
    assign rise = ~a_prev & a;  // Rising edge: 0->1 transition
    assign down = a_prev & a_inv;  // Falling edge: 1->0 transition

endmodule