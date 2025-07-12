/**
 * Enhanced TopModule - Parameterized Register with Synchronous Reset
 * 
 * New Features:
 * - Optional clock gating (CG_ENABLE parameter)
 * - Optional output buffering (OUTPUT_REG parameter)
 * - Optional enable signal (HAS_ENABLE parameter)
 * - Assertion-based parameter validation
 * - Balanced reset tree in GENERATE mode
 * - Metastability protection for reset
 */

module DFF #(
    parameter WIDTH = 1
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    always @(posedge clk) begin
        if (reset) q <= {WIDTH{1'b0}};
        else       q <= d;
    end
endmodule

module TopModule #(
    parameter WIDTH = 8,
    parameter IMPLEMENTATION = "SINGLE",  // "SINGLE" or "GENERATE"
    parameter CG_ENABLE = 0,             // Clock gating enable
    parameter HAS_ENABLE = 0,            // Enable signal
    parameter OUTPUT_REG = 0             // Additional output register
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    input enable,                        // Optional enable
    output [WIDTH-1:0] q
);

    // Parameter validation using assertions
    `ifndef SYNTHESIS
    initial begin
        assert(WIDTH >= 1) else $error("WIDTH must be at least 1");
        assert((IMPLEMENTATION == "SINGLE") || (IMPLEMENTATION == "GENERATE")) 
            else $error("IMPLEMENTATION must be 'SINGLE' or 'GENERATE'");
    end
    `endif

    // Metastability protection for reset
    reg sync_reset;
    always @(posedge clk) begin
        sync_reset <= reset;
    end

    // Clock gating logic
    wire gated_clk;
    generate
        if (CG_ENABLE && HAS_ENABLE) begin
            // Only gate clock when both features enabled
            reg last_enable;
            reg clk_en;
            always @(posedge clk or posedge sync_reset) begin
                if (sync_reset) begin
                    last_enable <= 1'b0;
                    clk_en <= 1'b0;
                end else begin
                    last_enable <= enable;
                    clk_en <= (enable && (d != q)) || (enable && !last_enable);
                end
            end
            assign gated_clk = clk & clk_en;
        end else begin
            assign gated_clk = clk;
        end
    endgenerate

    // Main register implementation
    wire [WIDTH-1:0] reg_out;
    generate
        if (IMPLEMENTATION == "SINGLE") begin : single_impl
            DFF #(.WIDTH(WIDTH)) dff_array (
                .clk(gated_clk),
                .reset(sync_reset),
                .d(HAS_ENABLE ? (enable ? d : reg_out) : d),
                .q(reg_out)
            );
        end
        else begin : generate_impl
            // Balanced reset tree implementation
            wire [WIDTH-1:0] local_reset;
            assign local_reset = {WIDTH{sync_reset}};
            
            genvar i;
            for (i = 0; i < WIDTH; i = i + 1) begin : dff_gen
                DFF #(.WIDTH(1)) dff_inst (
                    .clk(gated_clk),
                    .reset(local_reset[i]),
                    .d(HAS_ENABLE ? (enable ? d[i] : reg_out[i]) : d[i]),
                    .q(reg_out[i])
                );
            end
        end
    endgenerate

    // Optional output register
    generate
        if (OUTPUT_REG) begin : output_reg
            DFF #(.WIDTH(WIDTH)) output_ff (
                .clk(gated_clk),
                .reset(sync_reset),
                .d(reg_out),
                .q(q)
            );
        end else begin
            assign q = reg_out;
        end
    endgenerate

endmodule