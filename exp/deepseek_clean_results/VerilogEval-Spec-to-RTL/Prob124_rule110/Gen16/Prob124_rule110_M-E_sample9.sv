module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Boundary register (always 0)
    reg boundary = 1'b0;
    
    // Processing state machine
    reg [2:0] state = 0;
    reg [63:0] next_chunk;
    
    // 3-bit window for current processing
    reg [2:0] window;
    
    // Optimized Rule 110 logic
    function next_state;
        input [2:0] w;
        begin
            next_state = w[1] ^ (w[2] | (w[1] & w[0]));
        end
    endfunction
    
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    // Load first window
                    window <= {boundary, q[511], q[510]};
                    state <= 1;
                end
                1,2,3,4,5,6,7: begin
                    // Process current 64-bit chunk
                    for (integer i = 0; i < 64; i = i + 1) begin
                        next_chunk[i] = next_state(window);
                        if (i < 63) begin
                            window <= {window[1:0], q[511 - state*64 - i]};
                        end
                    end
                    
                    // Update output and shift window
                    q[511 - state*64 -: 64] <= next_chunk;
                    if (state < 7) begin
                        state <= state + 1;
                        window <= {q[511 - state*64 - 64], q[511 - state*64 - 65], q[511 - state*64 - 66]};
                    end else begin
                        state <= 0;
                    end
                end
            endcase
        end
    end

endmodule