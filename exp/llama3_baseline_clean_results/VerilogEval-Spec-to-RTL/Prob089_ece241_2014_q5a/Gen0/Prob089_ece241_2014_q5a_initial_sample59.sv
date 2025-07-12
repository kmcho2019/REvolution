module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // IDLE, RUNNING
reg carry; // carry flag for 2's complement

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // IDLE
        carry <= 1'b0;
        z <= 1'b0;
    end else begin
        case (state)
            2'b01: begin // IDLE
                if (~areset) begin
                    state <= 2'b10; // RUNNING
                end
            end
            2'b10: begin // RUNNING
                if (x) begin
                    carry <= 1'b1;
                    z <= ~x;
                end else if (carry) begin
                    z <= 1'b1;
                end else begin
                    z <= 1'b0;
                end
                if (areset) begin
                    state <= 2'b01; // IDLE
                    carry <= 1'b0;
                    z <= 1'b0;
                end
            end
        endcase
    end
end

endmodule