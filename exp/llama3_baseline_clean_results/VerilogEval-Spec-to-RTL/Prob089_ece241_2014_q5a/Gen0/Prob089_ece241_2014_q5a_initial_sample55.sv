module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
        z <= 1'b0;
    end else begin
        case(state)
            2'b00: begin
                if (x) begin
                    state <= 2'b01;
                    z <= 1'b1;
                end else begin
                    state <= 2'b00;
                    z <= 1'b0;
                end
            end
            2'b01: begin
                if (x) begin
                    state <= 2'b10;
                    z <= 1'b0;
                end else begin
                    state <= 2'b00;
                    z <= 1'b1;
                end
            end
            2'b10: begin
                if (x) begin
                    state <= 2'b10;
                    z <= 1'b0;
                end else begin
                    state <= 2'b01;
                    z <= 1'b1;
                end
            end
        endcase
    end
end

endmodule