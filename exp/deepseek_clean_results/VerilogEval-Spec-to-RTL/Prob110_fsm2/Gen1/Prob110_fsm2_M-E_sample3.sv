module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
        end else begin
            case ({state, j, k})
                3'b000: state <= 1'b0;  // OFF, j=0 -> stay OFF
                3'b010: state <= 1'b1;   // OFF, j=1 -> go ON
                3'b100: state <= 1'b1;   // ON, k=0 -> stay ON
                3'b101: state <= 1'b0;   // ON, k=1 -> go OFF
                default: state <= state; // catch-all for undefined cases
            endcase
        end
    end

    assign out = state;

endmodule