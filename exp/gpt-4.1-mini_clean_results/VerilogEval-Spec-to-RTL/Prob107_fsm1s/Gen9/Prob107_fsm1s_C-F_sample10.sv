module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state;

    // Synchronous state update with explicit if-else for clarity and synthesis friendliness
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
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

    // Moore output assigned continuously based on current state
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule