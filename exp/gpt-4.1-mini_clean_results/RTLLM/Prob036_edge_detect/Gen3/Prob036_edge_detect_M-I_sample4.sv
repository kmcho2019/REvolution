module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_prev;
    wire rise_edge, down_edge;
    wire update_en;

    // Combinational detection of edges
    assign rise_edge = (~a_prev) & a;
    assign down_edge = a_prev & (~a);
    assign update_en = rise_edge | down_edge;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
            rise   <= 1'b0;
            down   <= 1'b0;
        end else begin
            a_prev <= a;
            // Update rise and down only when edge detected to reduce switching
            if (update_en) begin
                rise <= rise_edge;
                down <= down_edge;
            end else begin
                rise <= 1'b0;
                down <= 1'b0;
            end
        end
    end

endmodule