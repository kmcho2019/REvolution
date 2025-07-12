module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    reg [1:0] state;

    // State encoding
    localparam S0 = 2'b00,
               S1 = 2'b01,
               S2 = 2'b10;

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
                    z <= x;
                end
                default: state <= S0;
            endcase
        end
    end

endmodule