module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Pipeline registers
    reg [255:0] current_state;
    reg [255:0] neighbor_counts [0:255];
    reg [255:0] next_state;
    
    // Circular shift registers for row wrapping
    wire [255:0] row_above, row_below;
    assign row_above = {q[15:0], q[255:16]};  // Shift down
    assign row_below = {q[239:0], q[255:240]}; // Shift up
    
    // Stage 1: Parallel neighbor counting
    always @(*) begin
        for (integer i = 0; i < 256; i = i + 1) begin
            // Get column positions with wrap-around
            integer left = (i % 16 == 0) ? i + 15 : i - 1;
            integer right = (i % 16 == 15) ? i - 15 : i + 1;
            
            // Count neighbors from 3 rows (above, current, below)
            neighbor_counts[i] = 
                row_above[left] + row_above[i] + row_above[right] +
                current_state[left] + current_state[right] +
                row_below[left] + row_below[i] + row_below[right];
        end
    end
    
    // Stage 2: State update logic
    always @(*) begin
        for (integer i = 0; i < 256; i = i + 1) begin
            case (neighbor_counts[i])
                2: next_state[i] = current_state[i];  // Stay same
                3: next_state[i] = 1'b1;              // Birth
                default: next_state[i] = 1'b0;        // Die
            endcase
        end
    end
    
    // Pipeline control and update
    always @(posedge clk) begin
        if (load) begin
            current_state <= data;
            q <= data;
        end else begin
            // Stage 1 register
            current_state <= q;
            
            // Stage 2 register (only update changed cells)
            for (integer i = 0; i < 256; i = i + 1) begin
                if (next_state[i] != q[i]) begin
                    q[i] <= next_state[i];
                end
            end
        end
    end

endmodule