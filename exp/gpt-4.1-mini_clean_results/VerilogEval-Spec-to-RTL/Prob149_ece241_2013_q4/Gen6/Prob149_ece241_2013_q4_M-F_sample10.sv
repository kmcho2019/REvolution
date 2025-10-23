module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Define water level states encoding
    // 2'b00 = Below s[0]
    // 2'b01 = Between s[1] and s[0]
    // 2'b10 = Between s[2] and s[1]
    // 2'b11 = Above s[2]
    reg [1:0] curr_level;
    reg [1:0] prev_level;

    // Combinational logic: decode sensors into water level states
    always @(*) begin
        case (s)
            3'b111: curr_level = 2'd3; // Above s[2]
            3'b011: curr_level = 2'd2; // Between s[2] and s[1]
            3'b001: curr_level = 2'd1; // Between s[1] and s[0]
            3'b000: curr_level = 2'd0; // Below s[0]
            // For any invalid or unexpected sensor states, treat conservatively as Below s0
            default: curr_level = 2'd0;
        endcase
    end

    // Determine if water level rose compared to previous
    wire rising_level = (curr_level > prev_level);

    // Sequential logic: store previous water level and update dfr
    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'd0;   // simulate low water level for a long time
            dfr        <= 1'b1;   // supplemental valve open on reset
        end else begin
            prev_level <= curr_level;
            dfr        <= rising_level ? 1'b1 : 1'b0;
        end
    end

    // Combinational output logic based on current water level
    always @(*) begin
        case (curr_level)
            2'd3: begin // Above s[2]
                fr0 = 1'b0;
                fr1 = 1'b0;
                fr2 = 1'b0;
            end
            2'd2: begin // Between s[2] and s[1]
                fr0 = 1'b1;
                fr1 = 1'b0;
                fr2 = 1'b0;
            end
            2'd1: begin // Between s[1] and s[0]
                fr0 = 1'b1;
                fr1 = 1'b1;
                fr2 = 1'b0;
            end
            2'd0: begin // Below s[0]
                fr0 = 1'b1;
                fr1 = 1'b1;
                fr2 = 1'b1;
            end
            default: begin // Should never occur, safe default
                fr0 = 1'b1;
                fr1 = 1'b1;
                fr2 = 1'b1;
            end
        endcase
    end

endmodule