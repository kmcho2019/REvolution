module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

parameter WIDTH = 512;
parameter CHUNK_SIZE = 64;
parameter NUM_CHUNKS = WIDTH/CHUNK_SIZE;

reg [CHUNK_SIZE-1:0] chunk_reg [NUM_CHUNKS-1:0];
reg [2:0] state;
reg gated_clk;
reg ready;

// Clock gating
always @(*) begin
    gated_clk = clk & (load | ~ready);
end

// State machine and chunk processing
always @(posedge gated_clk) begin
    if (load) begin
        // Load all chunks at once
        for (integer i = 0; i < NUM_CHUNKS; i = i + 1) begin
            chunk_reg[i] <= data[i*CHUNK_SIZE +: CHUNK_SIZE];
        end
        state <= 0;
        ready <= 0;
    end else if (~ready) begin
        // Process one chunk per cycle
        state <= state + 1;
        if (state == NUM_CHUNKS-1) ready <= 1;
        
        // Compute next state for current chunk
        for (integer i = 0; i < CHUNK_SIZE; i = i + 1) begin
            // Circular boundary handling
            wire left = (i == 0) ? 
                        chunk_reg[(state == 0) ? NUM_CHUNKS-1 : state-1][CHUNK_SIZE-1] : 
                        chunk_reg[state][i-1];
            wire right = (i == CHUNK_SIZE-1) ? 
                         chunk_reg[(state == NUM_CHUNKS-1) ? 0 : state+1][0] : 
                         chunk_reg[state][i+1];
            
            chunk_reg[state][i] <= left ^ right;
        end
    end
end

// Output assignment
always @(*) begin
    for (integer i = 0; i < NUM_CHUNKS; i = i + 1) begin
        q[i*CHUNK_SIZE +: CHUNK_SIZE] = chunk_reg[i];
    end
end

endmodule