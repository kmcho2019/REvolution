module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    localparam S0 = 1'b0; // Waiting for first '1'
    localparam S1 = 1'b1; // Inverting subsequent bits

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            case (state)
                S0: begin
                    z <= x;
                    if (x == 1'b1)
                        state <= S1;
                end
                S1: begin
                    z <= ~x;
                    state <= S1;
                end
            endcase
        end
    end

endmodule