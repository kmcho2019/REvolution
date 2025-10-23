module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detected;
    wire       in_changed;

    assign edge_detected = (~prev_in) & in;
    assign in_changed = |(prev_in ^ in); // High if any bit changed

    always @(posedge clk) begin
        if (in_changed) begin
            pedge   <= edge_detected;  // Register detected edges only if input changed
            prev_in <= in;             // Update previous input only if input changed
        end
    end

endmodule