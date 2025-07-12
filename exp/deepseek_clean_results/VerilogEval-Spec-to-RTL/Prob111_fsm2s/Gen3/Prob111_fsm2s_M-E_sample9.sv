module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;  // 0 = OFF, 1 = ON

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Synchronous reset to OFF
        end else begin
            case ({j,k})
                2'b10: state <= 1'b1;  // Set when j=1
                2'b01: state <= 1'b0;  // Reset when k=1
                default: state <= state;  // Hold otherwise
            endcase
        end
    end

    assign out = state;  // Direct Moore output

endmodule