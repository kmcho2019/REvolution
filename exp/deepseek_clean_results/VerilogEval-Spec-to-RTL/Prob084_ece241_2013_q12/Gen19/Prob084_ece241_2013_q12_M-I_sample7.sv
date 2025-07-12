module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    reg [7:0] shift_reg;
    wire [2:0] sel = {A, B, C};
    
    // Clock-gated shift register with circular shift
    always @(posedge clk) begin
        if (enable) begin
            // Circular shift implementation
            shift_reg <= {shift_reg[6:0], S};
        end
    end

    // Direct-index 8:1 multiplexer - more efficient in modern tools
    assign Z = shift_reg[sel];

    /* Alternative with explicit clock gating if needed:
    wire gated_clk;
    assign gated_clk = clk & enable;
    
    always @(posedge gated_clk) begin
        shift_reg <= {shift_reg[6:0], S};
    end
    */
endmodule