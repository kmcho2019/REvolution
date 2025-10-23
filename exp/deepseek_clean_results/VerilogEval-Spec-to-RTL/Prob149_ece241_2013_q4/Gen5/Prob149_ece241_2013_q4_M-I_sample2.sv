module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [2:0] prev_s;
    reg [1:0] state;

    // State encoding
    localparam BELOW_S0 = 2'b00;
    localparam BTWN_S1_S0 = 2'b01;
    localparam BTWN_S2_S1 = 2'b10;
    localparam ABOVE_S2 = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            state <= BELOW_S0;
            prev_s <= 3'b000;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            prev_s <= s;
            
            // State transition logic
            case (s)
                3'b000: state <= BELOW_S0;
                3'b001: state <= BTWN_S1_S0;
                3'b011: state <= BTWN_S2_S1;
                3'b111: state <= ABOVE_S2;
                default: state <= state; // Maintain current state for invalid combinations
            endcase

            // Output logic
            case (state)
                BELOW_S0: begin
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
                BTWN_S1_S0: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
                BTWN_S2_S1: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                end
                ABOVE_S2: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                end
            endcase

            // Detect rising water level (more sensors active than before)
            dfr <= (s > prev_s) && !reset;
        end
    end

endmodule