module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Define water level enumeration
    // 0 = below s[0]
    // 1 = between s[0] and s[1]
    // 2 = between s[1] and s[2]
    // 3 = above s[2]

    reg [1:0] prev_level;
    reg [1:0] current_level;

    // Decode sensors into water level using assign and always_comb style logic
    // Treat only these valid sensor states:
    // 3'b111: above s[2]
    // 3'b011: between s[2] and s[1]
    // 3'b001: between s[1] and s[0]
    // 3'b000: below s[0]
    // Any other pattern => below s[0]

    always @(*) begin
        case (s)
            3'b111: current_level = 2'd3; // above s[2]
            3'b011: current_level = 2'd2; // between s[2] and s[1]
            3'b001: current_level = 2'd1; // between s[1] and s[0]
            3'b000: current_level = 2'd0; // below s[0]
            default: current_level = 2'd0; // treat invalid as below s[0]
        endcase
    end

    // Synchronous process for updating prev_level and outputs
    always @(posedge clk) begin
        if (reset) begin
            // Reset state: assume long time below s[0], all nominal + supplemental valves open
            prev_level <= 2'd0;
            fr0       <= 1'b1;
            fr1       <= 1'b1;
            fr2       <= 1'b1;
            dfr       <= 1'b1;
        end else begin
            prev_level <= current_level;

            // Nominal flow valves based on current_level
            case (current_level)
                2'd3: begin
                    // Above s[2]: no nominal flow valves open
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                2'd2: begin
                    // Between s[2] and s[1]: fr0 only
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                2'd1: begin
                    // Between s[1] and s[0]: fr0, fr1
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                2'd0: begin
                    // Below s[0]: fr0, fr1, fr2 all open
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
                default: begin
                    // Defensive fallback, treat as below s[0]
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
            endcase

            // Supplemental flow valve dfr: open if water level rose compared to prev_level
            dfr <= (current_level > prev_level) ? 1'b1 : 1'b0;
        end
    end

endmodule