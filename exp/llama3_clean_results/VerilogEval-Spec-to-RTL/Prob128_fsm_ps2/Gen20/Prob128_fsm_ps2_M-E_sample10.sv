module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Stage 1: Message Start Detector (MSD)
logic msg_start, next_msg_start;

always_comb begin
    next_msg_start = 0;
    if (in[3]) begin
        next_msg_start = 1; // Set flag if start of message is detected
    end
end

always_ff @(posedge clk) begin
    if(reset) begin
        msg_start <= 0;
    end
    else begin
        msg_start <= next_msg_start;
    end
end

// Stage 2: Byte Counter (BC)
logic [1:0] byte_count, next_byte_count;

always_comb begin
    next_byte_count = byte_count;
    if (msg_start) begin
        next_byte_count = 1; // Reset count when new message starts
    end else if (byte_count != 0) begin
        next_byte_count = byte_count + 1; // Increment count
        if (next_byte_count == 3) begin
            next_byte_count = 0; // Reset count after 3 bytes
        end
    end
end

always_ff @(posedge clk) begin
    if(reset) begin
        byte_count <= 0;
    end
    else begin
        byte_count <= next_byte_count;
    end
end

// Stage 3: Message Completion Detector (MCD)
always_comb begin
    done = 0;
    if (byte_count == ) begin // Check if count has reached 3 ( because it will be incremented in the next cycle)
        done = 1; // Set done signal if message is complete
    end
end

endmodule