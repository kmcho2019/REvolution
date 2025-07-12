module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d;

    wire a_changed = (a != a_d);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d  <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else if (a_changed) begin
            // Update outputs only when input changes to save power
            rise <= (~a_d) & a;
            down <= a_d & (~a);
            a_d  <= a;
        end else begin
            // Keep outputs low when no change detected
            rise <= 1'b0;
            down <= 1'b0;
        end
    end

endmodule