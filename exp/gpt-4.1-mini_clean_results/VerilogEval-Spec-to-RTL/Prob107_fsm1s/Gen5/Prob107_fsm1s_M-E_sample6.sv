module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding: B=0, A=1
    reg state;

    // State transition and update
    always @(posedge clk) begin
        if (reset)
            state <= 1'b0; // B state on reset
        else begin
            if (state == 1'b0) begin // B state
                if (in == 1'b0)
                    state <= 1'b1; // move to A
                else
                    state <= 1'b0; // stay in B
            end else begin // A state
                if (in == 1'b0)
                    state <= 1'b0; // move to B
                else
                    state <= 1'b1; // stay in A
            end
        end
    end

    // Output logic: Moore output depends only on state
    always @(*) begin
        if (state == 1'b0)
            out = 1'b1; // B state output
        else
            out = 1'b0; // A state output
    end

endmodule