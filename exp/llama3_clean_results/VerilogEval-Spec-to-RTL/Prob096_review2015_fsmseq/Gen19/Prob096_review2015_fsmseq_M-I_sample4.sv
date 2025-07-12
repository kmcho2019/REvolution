module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] state;

always @(posedge clk) begin
    if(reset) begin
        state <= 4'b0000;
        start_shifting <= 0;
    end else begin
        case(state)
            4'b0000: state <= data ? 4'b0001 : 4'b0000;
            4'b0001: state <= data ? 4'b0011 : 4'b0000;
            4'b0011: state <= ~data ? 4'b0110 : 4'b0011;
            4'b0110: begin
                if(data) begin
                    state <= 4'b1101;
                    start_shifting <= 1;
                end else begin
                    state <= 4'b0000;
                end
            end
            4'b1101: state <= 4'b1101;
            default: state <= 4'b0000;
        endcase
    end
end

endmodule