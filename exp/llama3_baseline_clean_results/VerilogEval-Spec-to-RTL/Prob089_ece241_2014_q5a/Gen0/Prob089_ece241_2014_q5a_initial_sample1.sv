module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state;  // 0: idle, 1: compute, 2: sign_bit
reg sign_bit;
reg [1:0] output;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;  // idle state
        sign_bit <= 0;
        output <= 0;
    end else begin
        case (state)
            0: begin  // idle state
                if (~areset) begin
                    state <= 1;  // compute state
                    sign_bit <= 0;
                    output <= 0;
                end
            end
            1: begin  // compute state
                if (x) begin  // sign bit
                    sign_bit <= 1;
                    output <= ~x;
                end else begin
                    output <= {output[0], ~x};
                end
                if (areset) begin
                    state <= 0;  // idle state
                    sign_bit <= 0;
                    output <= 0;
                end
            end
            default: ;
        endcase
    end
end

always @(*) begin
    if (sign_bit) begin
        z = ~x;
    end else begin
        z = x;
    end
end

endmodule