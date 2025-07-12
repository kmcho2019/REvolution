module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    parameter S0 = 2'b00;  // Initial state (no history)
    parameter S1 = 2'b01;  // Got '1'
    parameter S2 = 2'b10;  // Got '10'

    reg [1:0] state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
        end else begin
            case (state)
                S0: state <= x ? S1 : S0;
                S1: state <= x ? S1 : S2;
                S2: state <= x ? S1 : S0;
                default: state <= S0;
            endcase
        end
    end

    // Output is high when in S2 (got '10') and current input is '1'
    assign z = (state == S2) & x;

endmodule