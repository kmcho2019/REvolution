module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state;

always @(posedge clock) begin
    case (state)
        2'b00: begin // Initial state, p=0, q=0
            if (a) begin
                state <= 2'b01; // Transition to state where p=1, q=0
                p <= 1'b1;
                q <= 1'b0;
            end else begin
                state <= 2'b00;
                p <= 1'b0;
                q <= 1'b0;
            end
        end
        2'b01: begin // State where p=1, q=0
            if (a) begin
                state <= 2'b10; // Transition to state where p=1, q=1
                p <= 1'b1;
                q <= 1'b1;
            end else begin
                state <= 2'b00;
                p <= 1'b0;
                q <= 1'b0;
            end
        end
        2'b10: begin // State where p=1, q=1
            if (!a) begin
                state <= 2'b00; // Transition back to initial state
                p <= 1'b0;
                q <= 1'b0;
            end else begin
                state <= 2'b10;
                p <= 1'b1;
                q <= 1'b1;
            end
        end
        default: begin
            state <= 2'b00;
            p <= 1'b0;
            q <= 1'b0;
        end
    endcase
end

always @(negedge clock) begin
    if (!a) begin
        q <= 1'b0;
    end
end

endmodule