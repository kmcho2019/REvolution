module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // 0: Initial, 1: First '1' detected, 2: Inverting
reg inv; // Flag to invert bits after first '1'

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        inv <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // Initial state
                if (x) begin
                    state <= 1;
                    inv <= 0;
                    z <= 1;
                end else begin
                    z <= 0;
                end
            end
            1: begin // First '1' detected
                state <= 2;
                inv <= 1;
                z <= ~x;
            end
            2: begin // Inverting state
                z <= ~x;
            end
        endcase
    end
end

endmodule