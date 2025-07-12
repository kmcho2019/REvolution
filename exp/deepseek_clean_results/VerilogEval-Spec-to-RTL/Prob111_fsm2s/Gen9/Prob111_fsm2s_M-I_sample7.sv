module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // Binary state representation (0=OFF, 1=ON)
    reg state;

    // State transitions and output
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to OFF state
        end else begin
            case (state)
                1'b0: state <= j;       // OFF -> ON if j=1, else stay OFF
                1'b1: state <= ~k;      // ON -> OFF if k=1, else stay ON
            endcase
        end
    end

    // Output is directly the state bit (Moore output)
    assign out = state;

endmodule