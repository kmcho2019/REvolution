module TopModule (
    input clk,
    input aresetn,  // active low asynchronous reset (negative edge)
    input x,
    output reg z
);

    // State encoding
    localparam [1:0]
        S0 = 2'b00, // no bits matched
        S1 = 2'b01, // matched '1'
        S2 = 2'b10; // matched '10'

    reg [1:0] state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            z <= 1'b0; // default output

            case (state)
                S0: begin
                    if (x)
                        state <= S1;
                    else
                        state <= S0;
                end
                S1: begin
                    if (!x)
                        state <= S2;
                    else
                        state <= S1;
                end
                S2: begin
                    if (x) begin
                        z <= 1'b1;  // sequence "101" detected
                        state <= S1;
                    end else
                        state <= S0;
                end
                default: state <= S0;
            endcase
        end
    end

endmodule