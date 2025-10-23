module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // 0: Idle, 1: Running
reg [1:0] nextState;
reg carry;

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Idle
        carry <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Idle
                if (~areset) begin
                    state <= 2'b01; // Running
                    carry <= 1'b1;
                end else begin
                    state <= 2'b00; // Idle
                end
            end
            2'b01: begin // Running
                if (areset) begin
                    state <= 2'b00; // Idle
                    carry <= 1'b0;
                end else begin
                    state <= 2'b01; // Running
                end
            end
        endcase
    end
end

assign z = (x ^ 1) ^ carry;

always @ (posedge clk) begin
    if (state == 2'b01) begin
        carry <= (x ^ carry);
    end
end

endmodule