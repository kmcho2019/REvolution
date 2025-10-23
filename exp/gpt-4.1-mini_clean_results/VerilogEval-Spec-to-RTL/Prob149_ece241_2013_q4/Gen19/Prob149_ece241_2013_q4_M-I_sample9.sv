module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Water level states encoding (2 bits)
    localparam BELOW_S0        = 2'b00;
    localparam BETWEEN_S1_S0   = 2'b01;
    localparam BETWEEN_S2_S1   = 2'b10;
    localparam ABOVE_S2        = 2'b11;

    // Function to decode sensors into a water level state
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            // Highest sensor asserted determines water level
            if (sensors[2]) begin
                decode_level = ABOVE_S2;
            end else if (sensors[1]) begin
                decode_level = BETWEEN_S2_S1;
            end else if (sensors[0]) begin
                decode_level = BETWEEN_S1_S0;
            end else begin
                decode_level = BELOW_S0;
            end
        end
    endfunction

    reg [1:0] curr_state;
    reg [1:0] prev_state;
    reg [1:0] next_state;

    // Compute next state based on current sensor input
    always @(*) begin
        next_state = decode_level(s);
    end

    // Sequential block: update states and outputs synchronously
    always @(posedge clk) begin
        if (reset) begin
            curr_state <= BELOW_S0;
            prev_state <= BELOW_S0;

            // Reset output: all valves asserted
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Update states
            prev_state <= curr_state;
            curr_state <= next_state;

            // Nominal flow valve outputs based on current water level
            case (next_state)
                ABOVE_S2: begin
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                BETWEEN_S2_S1: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                BETWEEN_S1_S0: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                BELOW_S0: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
                default: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
            endcase

            // Supplemental valve dfr asserted if level is rising
            // That is, current level state > previous level state
            dfr <= (next_state > prev_state) ? 1'b1 : 1'b0;
        end
    end

endmodule