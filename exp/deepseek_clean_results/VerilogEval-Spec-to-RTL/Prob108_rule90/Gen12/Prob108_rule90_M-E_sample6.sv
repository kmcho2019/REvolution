module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] buffer[0:1];  // Double buffer
    reg current_buffer;
    reg [8:0] counter;
    reg processing;
    reg [2:0] window;  // [left, center, right]

    always @(posedge clk) begin
        if (load) begin
            buffer[0] <= data;
            buffer[1] <= data;
            current_buffer <= 0;
            counter <= 0;
            processing <= 0;
            q <= data;
        end else begin
            if (!processing) begin
                // Start new processing cycle
                processing <= 1;
                counter <= 0;
                // Initialize window with boundary condition
                window <= {1'b0, buffer[current_buffer][0], buffer[current_buffer][1]};
            end else begin
                if (counter < 511) begin
                    // Shift window and calculate next state
                    buffer[!current_buffer][counter] <= window[2] ^ window[0];
                    window <= {window[1], window[2], buffer[current_buffer][counter+2]};
                    counter <= counter + 1;
                end else begin
                    // Final bit with boundary condition
                    buffer[!current_buffer][511] <= window[2] ^ 1'b0;
                    processing <= 0;
                    current_buffer <= !current_buffer;
                    q <= buffer[!current_buffer];
                end
            end
        end
    end

endmodule