module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // Gray-coded state encoding for power optimization
    parameter IDLE  = 2'b00;
    parameter GOT1  = 2'b01;
    parameter GOT10 = 2'b11;  // Gray code sequence: 00->01->11

    reg [1:0] state;
    wire clk_gated;
    reg clk_en;

    // Clock gating control
    always @(*) begin
        clk_en = (state != IDLE) || x;
    end

    // Gated clock
    assign clk_gated = clk & clk_en;

    // State transition logic with gray coding
    always @(posedge clk_gated or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
            z <= 1'b0;
        end else begin
            case (state)
                IDLE:  state <= x ? GOT1 : IDLE;
                GOT1:  state <= x ? GOT1 : GOT10;
                GOT10: begin
                    state <= x ? GOT1 : IDLE;
                    z <= x;  // Registered Mealy output
                end
                default: state <= IDLE;
            endcase
            
            // Clear z when not in detection state
            if (state != GOT10) z <= 1'b0;
        end
    end

endmodule