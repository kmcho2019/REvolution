module TopModule (
    input clk,
    input areset,
    input in,
    output out
);
    reg state;  // 0=A, 1=B (output is equal to state)

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;
        else
            state <= in ? state : ~state;  // Toggle state on 0, stay on 1
    end

    assign out = state;
endmodule