module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg sign_detected;
reg [1:0] state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        sign_detected <= 1'b0;
        state <= 2'b00;
        z <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                if (x == 1'b1) begin
                    sign_detected <= 1'b1;
                    state <= 2'b01;
                    z <= 1'b1;
                end else begin
                    z <= 1'b0;
                end
            end
            2'b01: begin
                z <= ~x;
                if (x == 1'b0) begin
                    state <= 2'b10;
                end
            end
            2'b10: begin
                z <= ~x;
            end
        endcase
    end
end

endmodule