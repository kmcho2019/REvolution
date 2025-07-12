module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state;
localparam A = 2'b01;
localparam B = 2'b10;

always @(*) begin
    if (areset) begin
        z <= 0;
        state <= A;
    end else begin
        case (state)
            A: begin
                z <= 0;
                if (x == 1'b0) begin
                    state <= A;
                end else begin
                    state <= B;
                end
            end
            B: begin
                z <= 1;
                state <= B;
            end
            default: begin
                state <= A;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (~areset) begin
        case (state)
            A: begin
                if (x == 1'b1) begin
                    z <= 1;
                end else begin
                    z <= 0;
                end
            end
            B: begin
                z <= x ? 0 : 1;
            end
        endcase
    end
end

endmodule