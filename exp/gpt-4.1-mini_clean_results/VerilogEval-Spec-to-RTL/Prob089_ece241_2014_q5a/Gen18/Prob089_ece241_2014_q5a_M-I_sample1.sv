module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    localparam S0 = 1'b0; // waiting for first '1' (carry not started)
    localparam S1 = 1'b1; // inverting subsequent bits (carry started)

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            case (state)
                S0: begin
                    if (x) begin
                        state <= S1;
                        z <= x;    // output same as input before carry starts
                    end else begin
                        state <= S0;
                        z <= x;
                    end
                end
                S1: begin
                    state <= S1;
                    z <= ~x;       // invert input bits after carry start
                end
                default: begin
                    state <= S0;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule