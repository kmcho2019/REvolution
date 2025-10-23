module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;
    wire input_changed;
    reg clk_enable;

    // Split XOR into two 4-bit operations to reduce fan-out
    assign edge_detect[3:0] = in[3:0] ^ prev_in[3:0];
    assign edge_detect[7:4] = in[7:4] ^ prev_in[7:4];

    // Clock gating control - only enable when inputs change
    assign input_changed = |edge_detect;
    always @(posedge clk) begin
        clk_enable <= input_changed;
    end

    // Clock-gated register update
    always @(posedge clk) begin
        if (clk_enable) begin
            prev_in <= in;
        end
    end

    // Registered output
    always @(posedge clk) begin
        anyedge <= edge_detect;
    end

endmodule