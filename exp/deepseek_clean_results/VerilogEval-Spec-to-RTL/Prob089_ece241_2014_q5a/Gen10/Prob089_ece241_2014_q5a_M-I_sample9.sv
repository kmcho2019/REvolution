module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg state; // 0: COPY, 1: INVERT
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
        end else begin
            if (~state & x) begin
                state <= 1'b1;
            end
        end
    end

    always @(*) begin
        if (areset) begin
            z = 1'bx; // don't-care during reset
        end else begin
            z = state ? ~x : x;
        end
    end

endmodule