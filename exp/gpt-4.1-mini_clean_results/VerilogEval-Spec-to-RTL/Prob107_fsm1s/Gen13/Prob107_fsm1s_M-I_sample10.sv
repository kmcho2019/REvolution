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

    // Synchronous state update with simplified ternary transition logic for better PPA
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
        end else begin
            state <= (state == B) ? (in ? B : A) : (in ? A : B);
        end
    end

    // Moore output assigned continuously based on current state
    assign out = (state == B);

endmodule