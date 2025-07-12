module TopModule(
    input clk,
    input aresetn,
    input x,
    output reg z
);

reg [1:0] state; // state register
parameter S0 = 2'b00; // initial state
parameter S1 = 2'b01; // seen '1' in the sequence
parameter S2 = 2'b10; // seen '10' in the sequence

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= S0; // reset to initial state
        z <= 1'b0; // reset output
    end else begin
        case (state)
            S0: begin
                if (x) begin
                    state <= S1; // seen '1', move to S1
                end else begin
                    state <= S0; // not seen '1', stay in S0
                end
                z <= 1'b0; // not in '101' sequence
            end
            S1: begin
                if (~x) begin
                    state <= S2; // seen '10', move to S2
                end else begin
                    state <= S1; // seen '11', stay in S1
                end
                z <= 1'b0; // not in '101' sequence
            end
            S2: begin
                if (x) begin
                    state <= S1; // seen '101', move to S1
                    z <= 1'b1; // in '101' sequence
                end else begin
                    state <= S0; // not in '101' sequence, move to S0
                    z <= 1'b0; // not in '101' sequence
                end
            end
            default: state <= S0;
        endcase
    end
end

endmodule