module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Rule 110 LUT (8 possible combinations of 3 bits)
    reg [7:0] rule110_lut;
    initial begin
        rule110_lut[0] = 0; // 000 -> 0
        rule110_lut[1] = 1; // 001 -> 1
        rule110_lut[2] = 1; // 010 -> 1
        rule110_lut[3] = 1; // 011 -> 1
        rule110_lut[4] = 0; // 100 -> 0
        rule110_lut[5] = 1; // 101 -> 1
        rule110_lut[6] = 1; // 110 -> 1
        rule110_lut[7] = 0; // 111 -> 0
    end

    // Shift register and processing logic
    reg [2:0] window;
    reg [8:0] counter; // 0-511 counter
    reg processing;
    reg [511:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            counter <= 0;
            processing <= 1;
            // Initialize window with first 3 bits (accounting for boundaries)
            window <= {data[511], data[0], data[1]};
        end else if (processing) begin
            // Compute next state for current position
            next_q[counter] <= rule110_lut[window];
            
            // Shift window for next position
            if (counter == 511) begin
                processing <= 0;
            end else begin
                window <= {window[1:0], 
                          (counter == 510) ? q[0] : 
                          (counter == 511) ? q[1] : q[counter+2]};
                counter <= counter + 1;
            end
            
            // Update output when complete
            if (counter == 511) begin
                q <= next_q;
            end
        end
    end

endmodule