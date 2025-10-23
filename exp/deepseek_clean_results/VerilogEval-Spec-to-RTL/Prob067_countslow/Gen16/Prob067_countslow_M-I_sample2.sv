module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

reg is_9;
reg gated_clk;

// Clock gating logic
always @(*) begin
    gated_clk = clk & (slowena | reset);
end

// Registered decade detection
always @(posedge clk) begin
    is_9 <= (q == 4'b1001);
end

// Counter logic with clock gating
always @(posedge gated_clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else if (slowena) begin
        if (is_9) begin
            q <= 4'b0000;
        end
        else begin
            case (q)
                4'b0000: q <= 4'b0001;
                4'b0001: q <= 4'b0010;
                4'b0010: q <= 4'b0011;
                4'b0011: q <= 4'b0100;
                4'b0100: q <= 4'b0101;
                4'b0101: q <= 4'b0110;
                4'b0110: q <= 4'b0111;
                4'b0111: q <= 4'b1000;
                4'b1000: q <= 4'b1001;
                default: q <= 4'b0000;
            endcase
        end
    end
end

endmodule