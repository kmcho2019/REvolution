module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg toggle;  // Toggles every valid input (detects pairs of inputs)
reg [9:0] accumulator;  // Stores running sum
reg [7:0] input_buffer; // Stores intermediate input

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        toggle <= 1'b0;
        accumulator <= 10'b0;
        data_out <= 10'b0;
        valid_out <= 1'b0;
        input_buffer <= 8'b0;
    end
    else begin
        // Default outputs
        valid_out <= 1'b0;
        
        if (valid_in) begin
            if (toggle) begin
                // On every 2nd input, accumulate to main accumulator
                accumulator <= accumulator + input_buffer + data_in;
                
                // Check if this was the 4th input (toggle has toggled twice)
                if (accumulator[9:8] == 2'b01) begin  // Detects 2 full toggle cycles
                    data_out <= accumulator + input_buffer + data_in;
                    valid_out <= 1'b1;
                    accumulator <= 10'b0;
                end
            end
            else begin
                // Store first input of pair
                input_buffer <= data_in;
            end
            
            toggle <= ~toggle;  // Toggle every valid input
        end
    end
end

endmodule