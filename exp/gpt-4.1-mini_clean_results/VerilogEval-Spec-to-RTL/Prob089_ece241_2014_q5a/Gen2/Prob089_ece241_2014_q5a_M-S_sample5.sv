module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    reg seen_one;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            seen_one <= 1'b0;
        else if (seen_one == 1'b0 && x == 1'b1)
            seen_one <= 1'b1;
        else
            seen_one <= seen_one;
    end

    // Moore output logic: registered output depends on state and input
    always @(posedge clk or posedge areset) begin
        if (areset)
            z <= 1'b0;
        else if (seen_one == 1'b0)
            z <= x;
        else
            z <= ~x;
    end

endmodule