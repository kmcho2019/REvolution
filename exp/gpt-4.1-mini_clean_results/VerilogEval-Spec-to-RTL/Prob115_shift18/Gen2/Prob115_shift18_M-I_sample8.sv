module TopModule(
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    reg [63:0] shifted;

    // Combinational shift logic using case for better synthesis optimization
    always @(*) begin
        case (amount)
            2'b00: shifted = q << 1;                       // shift left by 1
            2'b01: shifted = q << 8;                       // shift left by 8
            2'b10: shifted = $signed(q) >>> 1;             // arithmetic shift right by 1
            2'b11: shifted = $signed(q) >>> 8;             // arithmetic shift right by 8
            default: shifted = q;
        endcase
    end

    // Clock gating enable: load or ena active
    wire clk_en = load | ena;

    // Clock gating register (simple clock gating using enable, synthesis tool dependent)
    always @(posedge clk) begin
        if (clk_en) begin
            if (load) begin
                q <= data;
            end else begin
                q <= shifted;
            end
        end
    end

endmodule