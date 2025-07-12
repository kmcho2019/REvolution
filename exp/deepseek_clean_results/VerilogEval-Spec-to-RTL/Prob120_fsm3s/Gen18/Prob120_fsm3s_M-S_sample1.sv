module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset)
            state <= 2'b00;  // Reset to state A
        else if (state == 2'b00)  // State A
            state <= in ? 2'b01 : 2'b00;
        else if (state == 2'b01)  // State B
            state <= in ? 2'b01 : 2'b10;
        else if (state == 2'b10)  // State C
            state <= in ? 2'b11 : 2'b00;
        else                     // State D
            state <= in ? 2'b01 : 2'b10;
    end

    assign out = (state == 2'b11);  // Output high only in state D

endmodule