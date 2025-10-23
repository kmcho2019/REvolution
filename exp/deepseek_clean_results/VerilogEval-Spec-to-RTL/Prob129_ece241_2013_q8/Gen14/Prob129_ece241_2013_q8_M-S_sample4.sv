module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] state;  // 3 states: 00, 01, 10

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: state <= x ? 2'b01 : 2'b00;  // Got 1 -> move to 01
                2'b01: state <= x ? 2'b01 : 2'b10;  // Got 0 -> move to 10
                2'b10: state <= x ? 2'b01 : 2'b00;  // Got 1 -> output and reset
                default: state <= 2'b00;
            endcase
        end
    end

    assign z = (state == 2'b10) & x;  // Mealy output: in state 10 and see 1

endmodule