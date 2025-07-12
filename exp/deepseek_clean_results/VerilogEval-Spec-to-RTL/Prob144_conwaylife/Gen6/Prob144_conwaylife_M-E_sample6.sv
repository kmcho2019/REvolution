module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Systolic processing registers
    reg [255:0] current_state;
    reg [3:0] wave_pos;
    reg [255:0][3:0] neighbor_counts;
    reg processing_done;

    // Initialize neighbor counts to self (will be subtracted later)
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            neighbor_counts[i] = q[i] ? 4'd1 : 4'd0;
        end
    end

    // Diagonal wave processing
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            current_state <= data;
            wave_pos <= 4'd0;
            processing_done <= 1'b0;
            // Reset neighbor counts
            for (i = 0; i < 256; i = i + 1) begin
                neighbor_counts[i] <= data[i] ? 4'd1 : 4'd0;
            end
        end else begin
            if (!processing_done) begin
                // Process current diagonal wave
                for (i = 0; i < 256; i = i + 1) begin
                    // Check if cell is in current wave (i/16 + i%16 == wave_pos)
                    if ((i[7:4] + i[3:0]) == wave_pos) begin
                        // Propagate to 8 neighbors (with toroidal wrap-around)
                        neighbor_counts[{(i[7:4]-1)%16, (i[3:0]-1)%16}] <= neighbor_counts[{(i[7:4]-1)%16, (i[3:0]-1)%16}] + current_state[i];
                        neighbor_counts[{(i[7:4]-1)%16, i[3:0]}] <= neighbor_counts[{(i[7:4]-1)%16, i[3:0]}] + current_state[i];
                        neighbor_counts[{(i[7:4]-1)%16, (i[3:0]+1)%16}] <= neighbor_counts[{(i[7:4]-1)%16, (i[3:0]+1)%16}] + current_state[i];
                        neighbor_counts[{i[7:4], (i[3:0]-1)%16}] <= neighbor_counts[{i[7:4], (i[3:0]-1)%16}] + current_state[i];
                        neighbor_counts[{i[7:4], (i[3:0]+1)%16}] <= neighbor_counts[{i[7:4], (i[3:0]+1)%16}] + current_state[i];
                        neighbor_counts[{(i[7:4]+1)%16, (i[3:0]-1)%16}] <= neighbor_counts[{(i[7:4]+1)%16, (i[3:0]-1)%16}] + current_state[i];
                        neighbor_counts[{(i[7:4]+1)%16, i[3:0]}] <= neighbor_counts[{(i[7:4]+1)%16, i[3:0]}] + current_state[i];
                        neighbor_counts[{(i[7:4]+1)%16, (i[3:0]+1)%16}] <= neighbor_counts[{(i[7:4]+1)%16, (i[3:0]+1)%16}] + current_state[i];
                    end
                end
                
                // Advance wave position
                if (wave_pos == 4'd30) begin
                    processing_done <= 1'b1;
                    wave_pos <= 4'd0;
                end else begin
                    wave_pos <= wave_pos + 1;
                end
            end else begin
                // Final update after all neighbor counts are complete
                for (i = 0; i < 256; i = i + 1) begin
                    // Subtract self from count (since we included it initially)
                    reg [3:0] final_count = neighbor_counts[i] - (current_state[i] ? 4'd1 : 4'd0);
                    // Update rule
                    case (final_count)
                        4'd0, 4'd1: q[i] <= 1'b0;
                        4'd2: q[i] <= current_state[i];
                        4'd3: q[i] <= 1'b1;
                        default: q[i] <= 1'b0;
                    endcase
                end
                
                // Prepare for next cycle
                current_state <= q;
                processing_done <= 1'b0;
                // Reset neighbor counts (including self)
                for (i = 0; i < 256; i = i + 1) begin
                    neighbor_counts[i] <= q[i] ? 4'd1 : 4'd0;
                end
            end
        end
    end

endmodule