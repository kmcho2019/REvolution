module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // State register
reg [1:0] nextState; // Next state
reg z_out; // Output register

// One-hot encoding: A = 2'b01, B = 2'b10
// Note: This is a slightly simplified version of one-hot encoding
// where only the relevant state bit is set to '1'.

always @(*) begin
    case(state)
        2'b01: begin // State A
            if (x == 1'b0) begin
                nextState = 2'b01; // Stay in A
                z_out = 1'b0;
            end else begin
                nextState = 2'b10; // Move to B
                z_out = 1'b1;
            end
        end
        2'b10: begin // State B
            if (x == 1'b0) begin
                nextState = 2'b10; // Stay in B
                z_out = 1'b1;
            end else begin
                nextState = 2'b10; // Stay in B
                z_out = 1'b0;
            end
        end
        default: begin // Invalid state, reset to A
            nextState = 2'b01;
            z_out = 1'b0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        state <= nextState;
    end
end

assign z = z_out;

endmodule