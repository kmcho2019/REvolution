module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 0;
    end else begin
        case (state)
            2'd0: state <= 2'd1;
            2'd1: state <= 2'd2;
            2'd2: state <= 2'd3;
            2'd3: state <= 2'd0;
            default: state <= 2'd0;
        endcase
    end
end

assign valid_out = (state == 2'd0)? 1 : 0;
assign dout = (state == 2'd0)? d[3] :
              (state == 2'd1)? d[2] :
              (state == 2'd2)? d[1] :
              (state == 2'd3)? d[0] : 1'bx;

endmodule