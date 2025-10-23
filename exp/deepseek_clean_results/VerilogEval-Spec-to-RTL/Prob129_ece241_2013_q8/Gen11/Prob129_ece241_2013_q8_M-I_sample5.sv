module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    reg [1:0] state;
    reg x_prev;
    wire clk_enable = (x != x_prev);  // Clock gating when input changes

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= 2'b00;
            x_prev <= 1'b0;
            z <= 1'b0;
        end else if (clk_enable) begin
            x_prev <= x;
            case (state)
                2'b00: state <= x ? 2'b01 : 2'b00;
                2'b01: state <= x ? 2'b01 : 2'b10;
                2'b10: begin
                    state <= x ? 2'b01 : 2'b00;
                    z <= x;  // Mealy output
                end
                default: state <= 2'b00;
            endcase
        end else begin
            z <= 1'b0;  // Clear z when no state transition
        end
    end

endmodule