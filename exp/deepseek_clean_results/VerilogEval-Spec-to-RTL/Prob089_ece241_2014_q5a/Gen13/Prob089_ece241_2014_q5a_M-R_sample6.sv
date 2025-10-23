module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state; // 0: COPY, 1: INVERT

    // Combinational output logic
    assign z = state ? ~x : x;

    // Sequential state logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0;
        end else begin
            if (!state && x) begin
                state <= 1;
            end
        end
    end

endmodule