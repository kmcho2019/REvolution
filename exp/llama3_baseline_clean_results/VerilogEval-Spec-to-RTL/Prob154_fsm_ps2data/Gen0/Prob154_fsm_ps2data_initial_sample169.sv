module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  [23:0]  out_bytes,
    output          done
);

reg [1:0] state;
reg [7:0] msg1, msg2, msg3;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'd0;
        msg1 <= 8'd0;
        msg2 <= 8'd0;
        msg3 <= 8'd0;
    end else begin
        case (state)
            2'd0: begin
                if (in[3] == 1'b1) begin
                    msg1 <= in;
                    state <= 2'd1;
                end
            end
            2'd1: begin
                msg2 <= in;
                state <= 2'd2;
            end
            2'd2: begin
                msg3 <= in;
                state <= 2'd0;
            end
        endcase
    end
end

assign out_bytes = {msg1, msg2, msg3};
assign done = (state == 2'd0 && msg3 != 8'd0);

endmodule