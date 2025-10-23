module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Use 16-bit processing windows with 2-bit overlap for neighbor awareness
    localparam WINDOW_SIZE = 16;
    localparam OVERLAP = 2;
    localparam NUM_WINDOWS = (512 + WINDOW_SIZE - 1) / (WINDOW_SIZE - OVERLAP);
    
    reg [WINDOW_SIZE-1:0] processing_window;
    reg [WINDOW_SIZE-1:0] next_window;
    reg [3:0] window_counter;
    reg processing;
    
    // Boundary condition registers
    reg left_boundary = 0;
    reg right_boundary = 0;
    
    // State machine to control processing
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            processing <= 0;
            window_counter <= 0;
        end else begin
            if (!processing) begin
                // Start processing - load first window
                processing_window <= {q[WINDOW_SIZE-1:0], left_boundary};
                processing <= 1;
                window_counter <= 0;
            end else begin
                // Compute next state for current window
                for (integer i = 0; i < WINDOW_SIZE; i = i + 1) begin
                    wire left = (i == WINDOW_SIZE-1) ? right_boundary : processing_window[i+1];
                    wire center = processing_window[i];
                    wire right = (i == 0) ? left_boundary : processing_window[i-1];
                    
                    next_window[i] = (left & center & ~right) |  // 110
                                    (left & ~center & right) |   // 101
                                    (~left & center) |           // 011 or 010
                                    (~left & right);             // 001
                end
                
                // Store results and shift window
                if (window_counter < NUM_WINDOWS-1) begin
                    // Update corresponding portion of q
                    q[window_counter*(WINDOW_SIZE-OVERLAP) +: WINDOW_SIZE] <= next_window;
                    
                    // Load next window with overlap
                    processing_window <= {q[(window_counter+1)*(WINDOW_SIZE-OVERLAP) + WINDOW_SIZE-1 : 
                                         (window_counter+1)*(WINDOW_SIZE-OVERLAP)], 
                                         next_window[OVERLAP-1:0]};
                    window_counter <= window_counter + 1;
                end else begin
                    // Final window processing
                    q[512-WINDOW_SIZE : 511] <= next_window;
                    processing <= 0;
                end
            end
        end
    end

endmodule