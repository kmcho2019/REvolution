module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State parameters for better readability
    reg state;
    localparam B = 1'b0;
    localparam A = 1'b1;

    // State transitions with clear case statement
    always @(posedge clk) begin
        if (reset) begin
            state <= B;  // Synchronous reset to state B
        end else begin
            case (state)
                B: state <= in ? B : A;  // B stays if in=1, goes to A if in=0
                A: state <= in ? A : B;  // A stays if in=1, goes to B if in=0
            endcase
        end
    end

    // Optimized output assignment
    assign out = ~state;  // Direct bitwise NOT for minimal logic

endmodule