module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] edges_detected;
    wire       any_change;

    assign edges_detected = in ^ prev_in;
    assign any_change = |edges_detected;

    always @(posedge clk) begin
        if (any_change) begin
            anyedge <= edges_detected;
            prev_in <= in;
        end else begin
            anyedge <= 8'b0; // clear anyedge when no change
            // hold prev_in as is to avoid toggling registers unnecessarily
        end
    end

endmodule