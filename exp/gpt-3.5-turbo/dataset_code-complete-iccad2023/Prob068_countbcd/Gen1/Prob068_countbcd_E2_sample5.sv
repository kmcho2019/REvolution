module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

reg [3:0] q_ones = 4'b0000;
reg [3:0] q_tens = 4'b0000;
reg [3:0] q_hundreds = 4'b0000;
reg [3:0] q_thousands = 4'b0000;

reg [2:0] state = 3'b000; // State machine to control digit increments

always @(posedge clk) begin
    if (reset) begin
        q_ones <= 4'b0000;
        q_tens <= 4'b0000;
        q_hundreds <= 4'b0000;
        q_thousands <= 4'b0000;
        state <= 3'b000; // Reset state machine
    end else begin
        // Increment ones digit on every clock cycle
        q_ones <= (q_ones == 4'b1001) ? 4'b0000 : q_ones + 1;
        
        // State machine transitions to control tens, hundreds, and thousands digits
        case (state)
            3'b000: begin // State for ones digit
                // Move to tens state if ena[1] is high
                if (ena[1] == 1)
                    state <= 3'b001;
            end
            3'b001: begin // State for tens digit
                q_tens <= (q_tens == 4'b1001) ? 4'b0000 : q_tens + 1;
                // Move to hundreds state if ena[2] is high
                if (ena[2] == 1)
                    state <= 3'b010;
            end
            3'b010: begin // State for hundreds digit
                q_hundreds <= (q_hundreds == 4'b1001) ? 4'b0000 : q_hundreds + 1;
                // Move to thousands state if ena[3] is high
                if (ena[3] == 1)
                    state <= 3'b011;
            end
            3'b011: begin // State for thousands digit
                q_thousands <= (q_thousands == 4'b1001) ? 4'b0000 : q_thousands + 1;
                // Move back to ones state
                state <= 3'b000;
            end
        endcase
    end
end

assign q = {q_thousands, q_hundreds, q_tens, q_ones};

endmodule