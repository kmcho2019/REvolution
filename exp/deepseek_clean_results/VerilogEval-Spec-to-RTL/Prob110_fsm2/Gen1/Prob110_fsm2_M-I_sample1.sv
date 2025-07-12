module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;  // 0=OFF, 1=ON
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // Reset to OFF
        end else begin
            case (state)
                1'b0: state <= j;  // OFF state transition
                1'b1: state <= ~k; // ON state transition
            endcase
        end
    end
    
    assign out = state;  // Direct state to output
endmodule