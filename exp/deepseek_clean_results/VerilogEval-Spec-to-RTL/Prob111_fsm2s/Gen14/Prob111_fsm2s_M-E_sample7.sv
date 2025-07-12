module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;  // 0=OFF, 1=ON

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;
        end else begin
            case ({j,k})
                2'b10: state <= 1'b1;  // j=1 sets ON
                2'b01: state <= 1'b0;  // k=1 sets OFF
                2'b11: state <= 1'b0;   // both=1: priority to k
                default: state <= state; // keep state
            endcase
        end
    end

    assign out = state;

endmodule