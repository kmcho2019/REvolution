module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg first_one_seen;
reg [1:0] state; // 0 - initial, 1 - seen first '1', 2 - inverting bits

always @(posedge clk or posedge areset) begin
    if (areset) begin
        first_one_seen <= 0;
        state <= 0;
    end else begin
        case (state)
            0: begin
                if (x) begin
                    state <= 1;
                end
            end
            1: begin
                state <= 2;
            end
            2: begin
                // No change needed, as we're in the inversion state
            end
        endcase
    end
end

assign z = (state == 2 || state == 1)? ~x : x;

endmodule