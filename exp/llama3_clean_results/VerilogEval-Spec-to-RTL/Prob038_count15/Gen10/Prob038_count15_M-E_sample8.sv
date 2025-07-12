module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

// Use a lookup table approach to determine the next state of the counter
always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0; // Synchronous reset to 0
    end else begin
        // Use a case statement to implement the ROM lookup
        case (q)
            4'd0: q <= 4'd1;
            4'd1: q <= 4'd2;
            4'd2: q <= 4'd3;
            4'd3: q <= 4'd4;
            4'd4: q <= 4'd5;
            4'd5: q <= 4'd6;
            4'd6: q <= 4'd7;
            4'd7: q <= 4'd8;
            4'd8: q <= 4'd9;
            4'd9: q <= 4'd10;
            4'd10: q <= 4'd11;
            4'd11: q <= 4'd12;
            4'd12: q <= 4'd13;
            4'd13: q <= 4'd14;
            4'd14: q <= 4'd15;
            4'd15: q <= 4'd0; // Wrap around to 0
            default: q <= 4'd0; // Default to 0
        endcase
    end
end

endmodule