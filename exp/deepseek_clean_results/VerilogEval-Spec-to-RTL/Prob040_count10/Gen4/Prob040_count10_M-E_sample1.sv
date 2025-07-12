module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [4:0] johnson_cnt;

// Johnson counter logic
always @(posedge clk) begin
    if (reset) begin
        johnson_cnt <= 5'b00001;
    end
    else begin
        johnson_cnt <= {~johnson_cnt[0], johnson_cnt[4:1]};
    end
end

// Decode Johnson counter to binary output
always @(*) begin
    case (johnson_cnt)
        5'b00001: q = 4'd0;
        5'b00011: q = 4'd1;
        5'b00111: q = 4'd2;
        5'b01111: q = 4'd3;
        5'b11111: q = 4'd4;
        5'b11110: q = 4'd5;
        5'b11100: q = 4'd6;
        5'b11000: q = 4'd7;
        5'b10000: q = 4'd8;
        5'b00000: q = 4'd9;
        default:  q = 4'd0; // Should never occur
    endcase
end

endmodule