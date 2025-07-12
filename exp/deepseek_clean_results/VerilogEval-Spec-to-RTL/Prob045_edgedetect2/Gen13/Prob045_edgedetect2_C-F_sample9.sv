module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    parameter USE_CLOCK_GATING = 0;  // Optional power optimization
    
    reg [7:0] prev_in;
    wire [7:0] edge_detect = in ^ prev_in;
    wire gated_clk;

    generate
        if (USE_CLOCK_GATING) begin : gen_clock_gate
            // Simple clock gating when input is stable
            reg input_stable;
            always @(posedge clk) begin
                input_stable <= (in == prev_in);
            end
            assign gated_clk = clk & ~input_stable;
        end else begin : no_clock_gate
            assign gated_clk = clk;
        end
    endgenerate

    always @(posedge gated_clk) begin
        anyedge <= edge_detect;  // Registered edge detection
        prev_in <= in;           // Store current input
    end

endmodule