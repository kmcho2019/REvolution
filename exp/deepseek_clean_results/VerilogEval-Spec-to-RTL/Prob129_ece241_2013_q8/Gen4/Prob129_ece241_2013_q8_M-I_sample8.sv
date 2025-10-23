module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    parameter S0 = 2'b00;  // Initial state
    parameter S1 = 2'b01;  // Got '1'
    parameter S2 = 2'b10;  // Got '10'

    reg [1:0] state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            case (state)
                S0: begin
                    state <= x ? S1 : S0;
                    z <= 1'b0;
                end
                S1: begin
                    state <= x ? S1 : S2;
                    z <= 1'b0;
                end
                S2: begin
                    state <= x ? S1 : S0;
                    z <= x;  // Output is 1 only when in S2 and x=1
                end
            endcase
        end
    end

endmodule