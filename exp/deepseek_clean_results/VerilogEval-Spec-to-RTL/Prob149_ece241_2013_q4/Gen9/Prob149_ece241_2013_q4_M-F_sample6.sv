module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Correct water level encoding (0=highest, 3=lowest)
    reg [1:0] current_level;
    reg [1:0] prev_level;

    always @(*) begin
        case (s)
            3'b111: current_level = 2'b00;  // Above s[2]
            3'b011: current_level = 2'b01;  // Between s[2]-s[1]
            3'b001: current_level = 2'b10;  // Between s[1]-s[0]
            3'b000: current_level = 2'b11;  // Below s[0]
            default: current_level = 2'b11; // Default to lowest
        endcase
    end

    // History tracking and reset
    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'b11;  // Initialize to below s[0]
        end else begin
            prev_level <= current_level;
        end
    end

    // Correct output logic per specification
    assign fr0 = (current_level >= 2'b01);  // On for levels 1,2,3
    assign fr1 = (current_level >= 2'b10);  // On for levels 2,3
    assign fr2 = (current_level == 2'b11);  // On only for level 3

    // Supplemental flow when level is rising (current < previous)
    assign dfr = (current_level < prev_level);

    // Override all outputs during reset
    assign {fr2, fr1, fr0, dfr} = reset ? 4'b1111 : {fr2, fr1, fr0, dfr};

endmodule