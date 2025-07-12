module TopModule(
    input clk,
    input a,
    output q
);

reg q_reg;
reg [1:0] state; // 0: not seen low, 1: seen low, 2: seen high

always @(posedge clk) begin
    case(state)
        0: begin
            if(!a) state <= 1;
        end
        1: begin
            q_reg <= 1'b1;
            if(a) state <= 2;
        end
        2: begin
            if(a) state <= 2;
            else state <= 1;
            if(a) q_reg <= 1'b0;
        end
        default: state <= 0;
    endcase
end

always @(posedge clk) begin
    q <= q_reg;
end

endmodule