module TopModule (
    input clk,
    input d,
    output reg q
);

    // Generate phase-shifted clocks (simplified for FPGA implementation)
    wire clk_90, clk_180, clk_270;
    reg [3:0] phase_counter = 0;
    
    always @(posedge clk) begin
        phase_counter <= phase_counter + 1;
    end
    
    assign clk_90 = phase_counter[1];
    assign clk_180 = phase_counter[2];
    assign clk_270 = phase_counter[3];
    
    // Edge detection and data sampling
    reg d_sampled;
    reg edge_detected;
    
    always @(*) begin
        case ({clk, clk_90, clk_180, clk_270})
            4'b0001, 4'b0011, 4'b0111, 4'b1111: begin
                // Rising edge detection window
                d_sampled = d;
                edge_detected = 1;
            end
            4'b1110, 4'b1100, 4'b1000, 4'b0000: begin
                // Falling edge detection window
                d_sampled = d;
                edge_detected = 1;
            end
            default: edge_detected = 0;
        endcase
    end
    
    // Output update on detected edges
    always @(posedge edge_detected) begin
        q <= d_sampled;
    end

endmodule