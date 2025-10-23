module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg [0:0] state; // Using a single bit to represent the state
reg [0:0] next_state; // Next state register

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Asynchronous reset to OFF state
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        0: begin // OFF state
            if (j) begin
                next_state = 1; // Transition to ON if j=1
            end else begin
                next_state = 0; // Stay in OFF if j=0
            end
        end
        1: begin // ON state
            if (k) begin
                next_state = 0; // Transition to OFF if k=1
            end else begin
                next_state = 1; // Stay in ON if k=0
            end
        end
    endcase
end

// Output is determined by the current state
assign out = state;

endmodule