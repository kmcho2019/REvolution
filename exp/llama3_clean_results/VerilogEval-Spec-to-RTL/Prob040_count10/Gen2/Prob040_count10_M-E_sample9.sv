module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] johnson_counter;

always @ (posedge clk) begin
    if (reset) begin
        johnson_counter <= 4'd0;
    end else begin
        johnson_counter <= {johnson_counter[2:0], ~johnson_counter[3]};
    end
end

always @ (*) begin
    case (johnson_counter)
        4'd0: q = 4'd0;
        4'd1: q = 4'd1;
        4'd3: q = 4'd2;
        4'd7: q = 4'd3;
        4'db: q = 4'd4;
        4'dd: q = 4'd5;
        4'df: q = 4'd6;
        4'd7: q = 4'd7;
        4'db: q = 4'd8;
        4'dd: q = 4'd9;
        default: q = 4'd0;
    endcase
end

endmodule