module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // 0: Initial state, 1: First '1' seen, 2: Inverting bits
reg [7:0] counter; // Counter to track bits after first '1'

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        counter <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // Initial state
                if (x) begin
                    state <= 1;
                    z <= 1; // First '1' seen, output '1'
                end else begin
                    z <= 0; // Output '0' until first '1' is seen
                end
            end
            1: begin // First '1' seen, start inverting
                state <= 2;
                z <= ~x; // Invert subsequent bits
                counter <= counter + 1;
            end
            2: begin // Inverting bits
                z <= ~x; // Continue inverting bits
                counter <= counter + 1;
            end
        endcase
    end
end

endmodule