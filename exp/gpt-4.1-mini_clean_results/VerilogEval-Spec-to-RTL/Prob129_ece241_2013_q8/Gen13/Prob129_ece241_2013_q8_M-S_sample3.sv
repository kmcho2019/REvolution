module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    localparam S0 = 2'b00; // no bits matched
    localparam S1 = 2'b01; // matched '1'
    localparam S2 = 2'b10; // matched '10'

    reg [1:0] state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            z <= 1'b0; // default output

            case (state)
                S0: if (x)
                        state <= S1;
                    else
                        state <= S0;

                S1: if (!x)
                        state <= S2;
                    else
                        state <= S1;

                S2: if (x) begin
                        state <= S1;
                        z <= 1'b1; // detected "101"
                    end else
                        state <= S0;

                default: state <= S0;
            endcase
        end
    end

endmodule