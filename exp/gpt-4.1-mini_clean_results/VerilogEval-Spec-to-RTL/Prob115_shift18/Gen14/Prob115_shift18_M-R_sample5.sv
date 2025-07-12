module TopModule (
    input             clk,
    input             load,
    input             ena,
    input      [1:0]  amount,
    input      [63:0] data,
    output reg [63:0] q
);

    reg [63:0] shifted_val;
    reg signed [63:0] signed_q;

    always @* begin
        signed_q = q; // interpret q as signed for arithmetic right shifts
        // Default: no shift
        shifted_val = q;

        if (amount == 2'b00) begin
            // Shift left by 1
            shifted_val = q << 1;
        end else if (amount == 2'b01) begin
            // Shift left by 8
            shifted_val = q << 8;
        end else if (amount == 2'b10) begin
            // Arithmetic right shift by 1 using signed shift
            shifted_val = signed_q >>> 1;
        end else if (amount == 2'b11) begin
            // Arithmetic right shift by 8 using signed shift
            shifted_val = signed_q >>> 8;
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted_val;
        end
        // else retain current q
    end

endmodule