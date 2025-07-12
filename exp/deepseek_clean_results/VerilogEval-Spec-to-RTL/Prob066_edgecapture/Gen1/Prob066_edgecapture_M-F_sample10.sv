module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] out_reg;
    wire [31:0] edge_detect;

    // Edge detection combinational logic
    assign edge_detect = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out_reg <= 32'b0;
        end else begin
            // First store the current input for next cycle's comparison
            prev_in <= in;
            // Then update output register with any new detections
            out_reg <= out_reg | edge_detect;
        end
    end

    assign out = out_reg;

endmodule