module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4; // Using 3'd4 for consistency with the output width
    end else begin
        case (q)
            3'd4: q <= 3'd5;
            3'd5: q <= 3'd6;
            3'd6: q <= 3'd0;
            default: q <= 3'd0; // Ensuring a default case for any unexpected values
        endcase
    end
end

initial begin
    q <= 3'd4;
end

endmodule