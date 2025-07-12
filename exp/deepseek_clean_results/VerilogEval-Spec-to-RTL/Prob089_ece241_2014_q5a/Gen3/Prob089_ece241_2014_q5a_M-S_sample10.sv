module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg state;  // 0: COPY, 1: INVERT
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0;
            z <= 0;
        end else begin
            z <= state ? ~x : x;
            if (~state & x) state <= 1;
        end
    end

endmodule