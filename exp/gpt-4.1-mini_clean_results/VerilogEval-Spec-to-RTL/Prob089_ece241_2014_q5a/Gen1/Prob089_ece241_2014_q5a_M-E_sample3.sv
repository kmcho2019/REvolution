module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg found_one;

    // Sequential logic for found_one flag with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            found_one <= 1'b0;
        end else begin
            if (!found_one)
                found_one <= (x == 1'b1);
            // Once found_one is set, it remains set
        end
    end

    // Combinational output logic (Moore): output depends on found_one and x
    always @(*) begin
        if (!found_one)
            z = x;
        else
            z = ~x;
    end

endmodule