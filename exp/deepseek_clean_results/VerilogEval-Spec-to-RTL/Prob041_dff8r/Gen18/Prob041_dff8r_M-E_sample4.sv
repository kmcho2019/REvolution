module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    // Clock gating cells for each bit
    wire [7:0] gated_clk;
    wire [7:0] data_changed;

    // Data stability detection
    reg [7:0] prev_d;
    always @(posedge clk) begin
        prev_d <= d;
    end

    // Generate clock gating signals
    assign data_changed = prev_d ^ d;

    // Instantiate 8 DFFs with individual clock gating
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : dff_gen
            // Clock gating cell (behavioral model)
            assign gated_clk[i] = data_changed[i] ? clk : 1'b0;

            // DFF with synchronous reset
            always @(posedge gated_clk[i] or posedge reset) begin
                if (reset) begin
                    q[i] <= 1'b0;
                end else begin
                    q[i] <= d[i];
                end
            end
        end
    endgenerate

endmodule