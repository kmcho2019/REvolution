module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // 1-bit signal to represent the current state

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 1'b0; // reset to OFF state
        out <= 1'b0; // reset output to 0
    end else begin
        case(state)
            1'b0: 
                if(j) begin
                    state <= 1'b1; // transition to ON if j=1
                    out <= 1'b1; // set output to 1 in ON state
                end else begin
                    state <= 1'b0; // stay in OFF if j=0
                    out <= 1'b0; // keep output 0 in OFF state
                end
            1'b1: 
                if(k) begin
                    state <= 1'b0; // transition to OFF if k=1
                    out <= 1'b0; // set output to 0 in OFF state
                end else begin
                    state <= 1'b1; // stay in ON if k=0
                    out <= 1'b1; // keep output 1 in ON state
                end
        endcase
    end
end

endmodule