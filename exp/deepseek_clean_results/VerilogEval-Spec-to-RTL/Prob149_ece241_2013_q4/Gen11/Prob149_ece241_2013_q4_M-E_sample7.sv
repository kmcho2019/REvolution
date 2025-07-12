module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Current water level (2 bits: 0=below s0, 1=below s1, 2=below s2, 3=above s2)
    reg [1:0] current_level;
    reg [1:0] prev_level;
    reg rising_transition;

    // Priority encoder for water level
    always @(*) begin
        casez(s)
            3'b000: current_level = 2'b00; // Below s0
            3'b001: current_level = 2'b01; // Below s1
            3'b011: current_level = 2'b10; // Below s2
            3'b111: current_level = 2'b11; // Above s2
            default: current_level = 2'b00; // Invalid states treated as lowest
        endcase
    end

    // Transition history tracking
    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'b00;
            rising_transition <= 1'b1; // Force supplemental flow after reset
        end else begin
            prev_level <= current_level;
            // Detect if water level is rising
            rising_transition <= (current_level > prev_level);
        end
    end

    // Output logic
    assign fr0 = reset ? 1'b1 : (current_level != 2'b11);
    assign fr1 = reset ? 1'b1 : (current_level < 2'b10);
    assign fr2 = reset ? 1'b1 : (current_level < 2'b01);
    
    // Supplemental flow (active when level is rising and not at max)
    assign dfr = reset ? 1'b1 : (rising_transition && (current_level != 2'b11));

endmodule