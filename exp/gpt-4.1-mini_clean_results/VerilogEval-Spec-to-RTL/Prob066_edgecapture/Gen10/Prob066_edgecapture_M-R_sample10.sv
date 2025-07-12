module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] fall_edge;

    // Combinational logic to detect falling edges on each bit
    assign fall_edge = prev_in & ~in;

    // Register previous input, reset prev_in to current input to prevent false detections after reset
    always @(posedge clk) begin
        if (reset) begin
            prev_in <= in;
        end else begin
            prev_in <= in;
        end
    end

    // Sticky output register: OR previous output with detected falling edges, reset clears output
    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
        end else begin
            out <= out | fall_edge;
        end
    end

endmodule