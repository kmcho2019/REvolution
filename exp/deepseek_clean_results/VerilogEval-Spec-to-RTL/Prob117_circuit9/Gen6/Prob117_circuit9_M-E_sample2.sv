module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// State encoding
localparam STATE_4 = 3'b100;
localparam STATE_5 = 3'b101;
localparam STATE_6 = 3'b110;
localparam STATE_0 = 3'b000;
localparam STATE_1 = 3'b001;

always @(posedge clk) begin
    if (a) begin
        q <= STATE_4;  // Force state 4 when a is high
    end else begin
        case (q)
            STATE_4: q <= STATE_5;
            STATE_5: q <= STATE_6;
            STATE_6: q <= STATE_0;
            STATE_0: q <= STATE_1;
            default: q <= STATE_4;  // Handle undefined states
        endcase
    end
end

endmodule