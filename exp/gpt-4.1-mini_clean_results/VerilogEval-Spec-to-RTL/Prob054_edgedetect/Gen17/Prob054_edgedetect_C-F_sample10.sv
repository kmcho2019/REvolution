module TopModule (
    input             clk,
    input      [7:0]  in,
    output reg [7:0]  pedge
);

    reg [7:0] prev_in;

    wire [7:0] edge_detected;
    assign edge_detected = (~prev_in) & in;

    always @(posedge clk) begin
        // Update pedge only if a rising edge is detected (saving power by avoiding toggling when no edge)
        if (|edge_detected) begin
            pedge <= edge_detected;
            prev_in <= in;
        end else begin
            // Keep pedge low if no edge; update prev_in to track changes for next cycle
            pedge <= 8'b0;
            prev_in <= in;
        end
    end

endmodule