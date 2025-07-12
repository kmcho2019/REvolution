module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;

    wire change_detected = (in != prev_in);
    wire gated_clk;

    // Simple clock gating using enable signal
    // WARNING: In real ASIC flow, use proper clock gating cells or enable registers
    assign gated_clk = clk & change_detected;

    always @(posedge gated_clk) begin
        prev_in <= in;
    end

    always @(posedge clk) begin
        if (change_detected)
            anyedge <= in ^ prev_in;
        else
            anyedge <= 8'b0;
    end
endmodule