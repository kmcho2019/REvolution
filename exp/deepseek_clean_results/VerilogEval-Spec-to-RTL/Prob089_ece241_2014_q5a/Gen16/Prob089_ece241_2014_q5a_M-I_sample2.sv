module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state; // 0: COPY, 1: INVERT

    // Combinational output logic
    assign z = state ? ~x : x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0;
        end else if (!state && x) begin
            state <= 1;
        end
    end

endmodule