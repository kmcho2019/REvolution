module TopModule (
    input  wire clk,
    input  wire reset,            // synchronous active high reset
    input  wire pattern_detected, // input indicating detection of the proper bit pattern
    output wire shift_ena
);

    reg [2:0] ena_counter;
    reg       pattern_detected_d; // delayed version for edge detection

    always @(posedge clk) begin
        pattern_detected_d <= pattern_detected;

        if (reset) begin
            ena_counter <= 3'd4;  // assert shift_ena for 4 cycles on reset
        end else if (~pattern_detected_d & pattern_detected) begin
            // rising edge detected on pattern_detected
            ena_counter <= 3'd4;
        end else if (ena_counter != 3'd0) begin
            ena_counter <= ena_counter - 1;
        end
    end

    assign shift_ena = (ena_counter != 3'd0);

endmodule