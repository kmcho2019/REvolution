module TopModule (
    input clk,
    input in,
    output out
);

    reg state;
    wire d_next;

    assign d_next = in ^ state;

    always @(posedge clk) begin
        if (d_next != state) // Update state only when next differs, reducing toggling
            state <= d_next;
    end

    assign out = state;

endmodule