module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= B;  // reset to B state
        end else begin
            if (state == B) begin
                if (in == 1'b0)
                    state <= A;
                else
                    state <= B;
            end else begin // state == A
                if (in == 1'b0)
                    state <= B;
                else
                    state <= A;
            end
        end
    end

    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule