module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state;

initial state = 2'b00;

always @(posedge clock) begin
    case (state)
        2'b00: begin // Both p and q are low
            if (a) begin
                state <= 2'b10; // Transition to p high, q low
                p <= 1'b1;
                q <= 1'b0;
            end
        end
        2'b10: begin // p is high, q is low
            if (!a) begin
                state <= 2'b00; // Transition back to both low
                p <= 1'b0;
                q <= 1'b0;
            end else begin
                state <= 2'b11; // Transition to both high
                p <= 1'b1;
                q <= 1'b1;
            end
        end
        2'b11: begin // Both p and q are high
            if (!a) begin
                state <= 2'b01; // Transition to p low, q high
                p <= 1'b0;
                q <= 1'b1;
            end
        end
        2'b01: begin // p is low, q is high
            if (a) begin
                state <= 2'b11; // Transition to both high
                p <= 1'b1;
                q <= 1'b1;
            end
        end
        default: begin
            state <= 2'b00; // Default to both low
            p <= 1'b0;
            q <= 1'b0;
        end
    endcase
end

endmodule