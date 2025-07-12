module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: state <= x ? 2'b01 : 2'b00;  // Move to state 1 if '1' detected
                2'b01: state <= x ? 2'b01 : 2'b10;  // Stay if '1', move to state 2 if '0'
                2'b10: state <= x ? 2'b01 : 2'b00;  // On '1' pattern complete, else reset
                default: state <= 2'b00;
            endcase
        end
    end

    // Mealy output: pattern complete when in state 2 and current input is '1'
    assign z = (state == 2'b10) & x;

endmodule