module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    reg [2:0] cycle_count = 0;
    reg [7:0] data_buffer = 0;
    reg current_bit = 0;

    always @(posedge clk) begin
        if (reset) begin
            cycle_count <= 0;
            data_buffer <= 0;
            q <= 0;
            current_bit <= 0;
        end else begin
            // Capture current bit based on cycle count
            current_bit <= d[cycle_count];
            
            // Store captured bit in appropriate position
            data_buffer[cycle_count] <= current_bit;
            
            // Update cycle counter (0-7)
            cycle_count <= (cycle_count == 3'd7) ? 3'd0 : cycle_count + 1;
            
            // Update output only at end of cycle
            if (cycle_count == 3'd7) begin
                q <= data_buffer;
            end
        end
    end

endmodule