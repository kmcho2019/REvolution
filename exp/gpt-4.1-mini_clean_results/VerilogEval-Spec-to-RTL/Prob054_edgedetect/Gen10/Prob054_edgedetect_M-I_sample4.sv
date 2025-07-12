module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;
    wire in_changed;
    wire pedge_update_en;

    // Detect any change in input vector for enabling prev_in update
    assign in_changed = |(in ^ prev_in);

    // Combinational detection of 0->1 transitions (positive edges)
    assign edge_detect = (~prev_in) & in;

    // Enable pedge update only when an edge is detected (non-zero edge_detect)
    assign pedge_update_en = |edge_detect;

    // Update prev_in only when input changes to reduce toggling
    always @(posedge clk) begin
        if (in_changed)
            prev_in <= in;
    end

    // Update pedge only when edge detected to reduce unnecessary toggling
    always @(posedge clk) begin
        if (pedge_update_en)
            pedge <= edge_detect;
        else
            pedge <= 8'b0;
    end

endmodule