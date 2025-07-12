module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg state;
reg w1, w2, w3;

always @(posedge clk) begin
    if(reset) begin
        state <= 1'b0; // State A
        w1 <= 1'b0;
        w2 <= 1'b0;
        w3 <= 1'b0;
    end else begin
        if(state == 1'b0) begin // State A
            if(s) begin
                state <= 1'b1; // Transition to State B
            end
        end else begin // State B
            w3 <= w2;
            w2 <= w1;
            w1 <= w;
        end
    end
end

always @(*) begin
    if(state == 1'b1) begin // State B
        if((w1 + w2 + w3) == 2) begin
            z = 1'b1;
        end else begin
            z = 1'b0;
        end
    end else begin // State A
        z = 1'b0;
    end
end

endmodule