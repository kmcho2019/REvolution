module TopModule(clk, reset, j, k, out);
    input clk, reset, j, k;
    output out;
    reg [1:0] state; // Using 2 bits to represent the two states
    parameter OFF = 1'b0, ON = 1'b1;

    always @(posedge clk) begin
        if(reset) begin
            state <= OFF; // Reset to OFF state when reset is high
        end else begin
            case(state)
                OFF: state <= (j == 1'b1) ? ON : OFF;
                ON:  state <= (k == 1'b1) ? OFF : ON;
                default: state <= OFF; // Default case, not expected to occur
            endcase
        end
    end

    assign out = (state == ON) ? 1'b1 : 1'b0;
endmodule