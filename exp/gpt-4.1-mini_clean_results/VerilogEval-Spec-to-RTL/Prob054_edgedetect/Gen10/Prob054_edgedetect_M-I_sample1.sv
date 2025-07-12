module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detected;
    wire        update_enable;

    // Detect 0->1 edges per bit
    assign edge_detected = (~prev_in) & in;

    // Enable updating registers only if input changes to reduce switching activity
    assign update_enable = (in != prev_in);

    always @(posedge clk) begin
        if (update_enable) begin
            pedge   <= edge_detected;  // Update output only when input changes
            prev_in <= in;             // Update previous input
        end else begin
            pedge   <= pedge;          // Hold previous output
            prev_in <= prev_in;        // Hold previous input
        end
    end

endmodule