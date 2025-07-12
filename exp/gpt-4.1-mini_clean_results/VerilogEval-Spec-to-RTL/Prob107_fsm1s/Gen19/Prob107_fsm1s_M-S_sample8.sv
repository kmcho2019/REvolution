module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;  // B state
        else if (state == 1'b0) begin
            if (in == 1'b0)
                state <= 1'b1;  // A
            else
                state <= 1'b0;  // B
        end else begin
            if (in == 1'b0)
                state <= 1'b0;  // B
            else
                state <= 1'b1;  // A
        end
    end

    assign out = ~state;  // out=1 for B(0), out=0 for A(1)

endmodule