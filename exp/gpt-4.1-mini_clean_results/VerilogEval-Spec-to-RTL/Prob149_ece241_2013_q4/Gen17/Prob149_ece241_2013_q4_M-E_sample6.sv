module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Water level encoding:
    // 2'd3: Above s[2]    (s = 3'b111)
    // 2'd2: Between s[2] and s[1] (s = 3'b011)
    // 2'd1: Between s[1] and s[0] (s = 3'b001)
    // 2'd0: Below s[0]    (s = 3'b000)
    //
    // Invalid sensor states map to closest lower state by priority order.

    reg [1:0] current_level;
    reg [1:0] previous_level;

    // Decode sensor inputs to discrete level
    // Priority matching with exact sensor patterns per spec
    wire [1:0] decoded_level = 
        (s == 3'b111) ? 2'd3 :    // above s[2]
        (s == 3'b011) ? 2'd2 :    // between s[2] and s[1]
        (s == 3'b001) ? 2'd1 :    // between s[1] and s[0]
        (s == 3'b000) ? 2'd0 :    // below s[0]
        // For any other pattern, choose closest lower level (e.g., treat 3'b010 as 2'd1)
        (s[2] ? 2'd3 : (s[1] ? 2'd2 : (s[0] ? 2'd1 : 2'd0)));

    always @(posedge clk) begin
        if (reset) begin
            current_level <= 2'd0;  // below s[0]
            previous_level <= 2'd0;
            dfr <= 1'b1;           // supplemental flow open on reset
        end else begin
            current_level <= decoded_level;
            dfr <= (decoded_level > current_level) ? 1'b1 : 1'b0;
            previous_level <= current_level;
        end
    end

    // Nominal flow valve outputs combinational from current_level:
    always @(*) begin
        case (current_level)
            2'd3: begin // above s[2], no nominal valves
                fr0 = 1'b0;
                fr1 = 1'b0;
                fr2 = 1'b0;
            end
            2'd2: begin // between s[2] and s[1], fr0 only
                fr0 = 1'b1;
                fr1 = 1'b0;
                fr2 = 1'b0;
            end
            2'd1: begin // between s[1] and s[0], fr0 and fr1
                fr0 = 1'b1;
                fr1 = 1'b1;
                fr2 = 1'b0;
            end
            2'd0: begin // below s[0], fr0, fr1, fr2
                fr0 = 1'b1;
                fr1 = 1'b1;
                fr2 = 1'b1;
            end
            default: begin // safe default: all zero
                fr0 = 1'b0;
                fr1 = 1'b0;
                fr2 = 1'b0;
            end
        endcase
    end

endmodule