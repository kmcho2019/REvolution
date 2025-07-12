module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg [3:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 4'b0001;  // State A
        end else begin
            case (1'b1)
                state[0]: state <= in ? 4'b0010 : 4'b0001;  // A->B or A->A
                state[1]: state <= in ? 4'b0010 : 4'b0100;  // B->B or B->C
                state[2]: state <= in ? 4'b1000 : 4'b0001;  // C->D or C->A
                state[3]: state <= in ? 4'b0010 : 4'b0100;  // D->B or D->C
            endcase
        end
    end

    assign out = state[3];  // Direct output from state D bit

endmodule