module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state;

always @(posedge clock or negedge clock) begin
    case(state)
        2'b00: begin // S0
            if (a && clock) begin
                state <= 2'b01; // Transition to S1
                p <= 1'b1;
            end
            else if (!clock && !a) begin
                state <= 2'b00; // Stay in S0
            end
            else begin
                state <= 2'b00; // Stay in S0
            end
        end
        2'b01: begin // S1
            if (a && clock) begin
                state <= 2'b10; // Transition to S2
                q <= 1'b1;
            end
            else if (!clock && !a) begin
                state <= 2'b11; // Transition to S3
            end
            else begin
                state <= 2'b01; // Stay in S1
            end
        end
        2'b10: begin // S2
            if (!clock && !a) begin
                state <= 2'b11; // Transition to S3
                p <= 1'b0;
            end
            else begin
                state <= 2'b10; // Stay in S2
            end
        end
        2'b11: begin // S3
            if (!a && !clock) begin
                state <= 2'b00; // Transition to S0
                q <= 1'b0;
            end
            else begin
                state <= 2'b11; // Stay in S3
            end
        end
        default: begin
            state <= 2'b00; // Default to S0
        end
    endcase
end

endmodule