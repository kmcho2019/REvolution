module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

always @(in, state) begin
    case (state)
        2'b00: begin // State A
            if (~in) begin
                next_state = 2'b00; // Next state is A when in=0
            end else begin
                next_state = 2'b01; // Next state is B when in=1
            end
            out = 1'b0; // Output is 0
        end
        2'b01: begin // State B
            if (~in) begin
                next_state = 2'b10; // Next state is C when in=0
            end else begin
                next_state = 2'b01; // Next state is B when in=1
            end
            out = 1'b0; // Output is 0
        end
        2'b10: begin // State C
            if (~in) begin
                next_state = 2'b00; // Next state is A when in=0
            end else begin
                next_state = 2'b11; // Next state is D when in=1
            end
            out = 1'b0; // Output is 0
        end
        2'b11: begin // State D
            if (~in) begin
                next_state = 2'b10; // Next state is C when in=0
            end else begin
                next_state = 2'b01; // Next state is B when in=1
            end
            out = 1'b1; // Output is 1
        end
    endcase
end

endmodule