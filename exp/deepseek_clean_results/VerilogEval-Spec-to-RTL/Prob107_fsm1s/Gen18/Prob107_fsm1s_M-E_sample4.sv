module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] state_shift;  // [1]=A, [0]=B

    always @(posedge clk) begin
        if (reset) begin
            state_shift <= 2'b01;  // Reset to B state
        end else begin
            if (state_shift[0]) begin  // Current state is B
                state_shift <= in ? 2'b01 : 2'b10;
            end else begin             // Current state is A
                state_shift <= in ? 2'b10 : 2'b01;
            end
        end
    end

    assign out = state_shift[0];  // out=1 when in B state

endmodule