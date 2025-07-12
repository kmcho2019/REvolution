module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire rise,
    output wire down
);

    reg a_prev;
    wire a_changed;

    // Detect if input 'a' has changed
    assign a_changed = (a_prev != a);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_prev <= 1'b0;
        else if (a_changed)
            a_prev <= a;
        // else hold previous state to save toggling
    end

    assign rise = (~a_prev) & a;
    assign down = a_prev & (~a);

endmodule