module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_prev;      // Stores previous value of 'a'
    wire a_changed;  // Indicates when 'a' has changed
    wire clk_en;     // Clock enable signal

    // Clock gating logic - only enable when 'a' changes
    assign a_changed = (a != a_prev);
    assign clk_en = a_changed;

    // Sequential logic with clock gating
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
            rise   <= 1'b0;
            down   <= 1'b0;
        end else if (clk_en) begin
            a_prev <= a;
            rise   <= ~a_prev & a;  // Registered rising edge
            down   <= a_prev & ~a;  // Registered falling edge
        end else begin
            rise   <= 1'b0;         // Clear outputs when no edge
            down   <= 1'b0;
        end
    end

endmodule