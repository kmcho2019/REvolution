module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] current_state, next_state;

// One-hot encoding for states
parameter A = 2'b01;
parameter B = 2'b10;

// Asynchronous reset
always @(areset or current_state or x) begin
    if (areset) begin
        current_state = A;
    end else begin
        case (current_state)
            A: begin
                if (~x) begin
                    next_state = A;
                    z = 1'b0;
                end else begin
                    next_state = B;
                    z = 1'b1;
                end
            end
            B: begin
                if (~x) begin
                    next_state = B;
                    z = 1'b1;
                end else begin
                    next_state = B;
                    z = 1'b0;
                end
            end
            default: begin
                next_state = A;
                z = 1'b0;
            end
        endcase
    end
end

// Sequential logic
always @(posedge clk) begin
    if (~areset) begin
        current_state = next_state;
    end else begin
        current_state = A;
    end
end

endmodule