module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state;
localparam A = 2'b10;
localparam B = 2'b01;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
        z <= 0;
    end else begin
        case(state)
            A: begin
                if (x == 0) begin
                    state <= A;
                    z <= 0;
                end else begin
                    state <= B;
                    z <= 1;
                end
            end
            B: begin
                if (x == 0) begin
                    state <= B;
                    z <= 1;
                end else begin
                    state <= B;
                    z <= 0;
                end
            end
            default: begin
                state <= A;
                z <= 0;
            end
        endcase
    end
end

endmodule