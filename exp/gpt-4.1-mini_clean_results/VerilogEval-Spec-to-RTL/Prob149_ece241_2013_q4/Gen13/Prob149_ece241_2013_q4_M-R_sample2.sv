module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Define water level states explicitly
    typedef enum logic [1:0] {
        BELOW_S0      = 2'd0,
        BETWEEN_S1_S0 = 2'd1,
        BETWEEN_S2_S1 = 2'd2,
        ABOVE_S2      = 2'd3
    } water_level_t;

    // Function to decode sensors 's' to water level
    function automatic water_level_t decode_level(input [2:0] sensors);
        begin
            case (sensors)
                3'b111: decode_level = ABOVE_S2;      // Above s[2]: all sensors asserted
                3'b110: decode_level = BETWEEN_S2_S1; // Between s[2] and s[1]: s[2]=1,s[1]=1,s[0]=0
                3'b100: decode_level = BETWEEN_S1_S0; // Between s[1] and s[0]: only s[2] asserted? 
                3'b010: decode_level = BETWEEN_S1_S0; // If only s[1] asserted, treat as BETWEEN_S1_S0 per problem intent
                3'b001: decode_level = BETWEEN_S1_S0; // If only s[0] asserted, also BETWEEN_S1_S0 
                3'b000: decode_level = BELOW_S0;      // Below s[0]: no sensors asserted
                default: decode_level = BELOW_S0;     // Any other pattern defaults to BELOW_S0 safely
            endcase
        end
    endfunction

    // Registers to hold previous sensor input and water level at last sensor change
    water_level_t current_level, prev_level;
    reg [2:0] prev_s;

    always_ff @(posedge clk) begin
        if (reset) begin
            prev_s     <= 3'b000;
            prev_level <= BELOW_S0;
        end else begin
            current_level = decode_level(s);
            if (s != prev_s) begin
                prev_s     <= s;
                prev_level <= current_level;
            end
        end
    end

    // Need to assign current_level combinationally to outputs
    // Use a combinational signal for current_level decoded directly from input 's'
    wire [1:0] decoded_level = decode_level(s);

    // Assign nominal flow valve outputs as per table:
    // Above s[2] (111): fr2=0, fr1=0, fr0=0
    // Between s[2] and s[1] (110): fr0=1 only => fr2=0, fr1=0, fr0=1
    // Between s[1] and s[0] (100,010,001): fr0=1, fr1=1 => fr2=0, fr1=1, fr0=1
    // Below s[0] (000): fr2=1, fr1=1, fr0=1

    assign fr2 = (decoded_level == BELOW_S0) ? 1'b1 : 1'b0;
    assign fr1 = ((decoded_level == BELOW_S0) || (decoded_level == BETWEEN_S1_S0)) ? 1'b1 : 1'b0;
    assign fr0 = (decoded_level != ABOVE_S2) ? 1'b1 : 1'b0;

    // dfr asserted if current water level (decoded from s) > previous water level (prev_level)
    assign dfr = (decoded_level > prev_level);

endmodule