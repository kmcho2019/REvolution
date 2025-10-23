module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Configuration
    localparam CHUNK_SIZE = 64;
    localparam NUM_CHUNKS = 512/CHUNK_SIZE;
    
    // State registers
    reg [511:0] current_state, next_state;
    reg [CHUNK_SIZE+1:0] left_buffer;  // +2 for boundary conditions
    reg [CHUNK_SIZE+1:0] right_buffer;
    
    // Control logic
    reg [2:0] cycle_count;
    reg processing;
    
    // Function implementing Rule 110 logic
    function automatic rule110;
        input left, center, right;
        begin
            case ({left, center, right})
                3'b111: rule110 = 0;
                3'b110: rule110 = 1;
                3'b101: rule110 = 1;
                3'b100: rule110 = 0;
                3'b011: rule110 = 1;
                3'b010: rule110 = 1;
                3'b001: rule110 = 1;
                3'b000: rule110 = 0;
            endcase
        end
    endfunction

    // Processing logic
    always @(posedge clk) begin
        if (load) begin
            current_state <= data;
            next_state <= data;
            cycle_count <= 0;
            processing <= 0;
        end else begin
            if (!processing) begin
                // Start new processing cycle
                left_buffer <= {1'b0, current_state[511:511-CHUNK_SIZE]};
                right_buffer <= {current_state[CHUNK_SIZE-1:0], 1'b0};
                cycle_count <= 0;
                processing <= 1;
            end else begin
                // Process current chunk
                for (integer i = 0; i < CHUNK_SIZE; i = i + 1) begin
                    next_state[cycle_count*CHUNK_SIZE + i] <= 
                        rule110(left_buffer[i+2], left_buffer[i+1], left_buffer[i]);
                end
                
                // Shift buffers for next chunk
                left_buffer <= {1'b0, current_state[511-cycle_count*CHUNK_SIZE:511-(cycle_count+1)*CHUNK_SIZE]};
                right_buffer <= {current_state[(cycle_count+1)*CHUNK_SIZE-1:cycle_count*CHUNK_SIZE], 1'b0};
                
                // Update counters
                if (cycle_count == NUM_CHUNKS-1) begin
                    processing <= 0;
                    current_state <= next_state;
                end
                cycle_count <= cycle_count + 1;
            end
        end
    end

    // Output
    always @(*) begin
        q = current_state;
    end

endmodule