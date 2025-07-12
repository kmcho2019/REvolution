module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state; // 0=B, 1=A

    always @(posedge clk) begin
        state <= reset ? 0 : (state ? in : ~in);
    end

    assign out = ~state;
endmodule