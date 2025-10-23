module TopModule (
    input clk,
    input in,
    output out
);

    reg toggle_state;

    always @(posedge clk) begin
        if (in) begin
            toggle_state <= ~toggle_state;
        end
    end

    assign out = toggle_state;

endmodule