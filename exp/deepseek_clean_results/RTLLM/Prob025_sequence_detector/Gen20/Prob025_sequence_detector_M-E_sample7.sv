module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

reg [3:0] history_buffer;
reg [1:0] ptr;  // Circular buffer pointer
reg [2:0] match_counter;
wire [3:0] current_window;
wire pattern_match;

// Circular buffer implementation
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        history_buffer <= 4'b0;
        ptr <= 2'b0;
    end else begin
        history_buffer[ptr] <= data_in;
        ptr <= ptr + 1;
    end
end

// Create current 4-bit window by rotating
assign current_window = {history_buffer[ptr-1], 
                        history_buffer[ptr-2], 
                        history_buffer[ptr-3], 
                        history_buffer[ptr]};

// XOR-based pattern matching (1001)
assign pattern_match = ~current_window[3] &  // 1
                       ~current_window[2] &  // 0
                       ~current_window[1] &  // 0
                        current_window[0];    // 1

// Detection logic with optional noise filtering
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        sequence_detected <= 1'b0;
        match_counter <= 3'b0;
    end else begin
        if (pattern_match) begin
            if (match_counter == 3'd3) begin
                sequence_detected <= 1'b1;
                match_counter <= 3'b0;
            end else begin
                match_counter <= match_counter + 1;
                sequence_detected <= 1'b0;
            end
        end else begin
            sequence_detected <= 1'b0;
            match_counter <= 3'b0;
        end
    end
end

endmodule