module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Internal shift register with boundary padding
    reg [513:0] shift_reg;  // q[-1] and q[512] are boundaries (0)
    reg [4:0] phase;        // Pipeline phase counter (0-15)
    reg processing;         // Active during computation phases
    
    // Next state computation for current 32-bit chunk
    wire [31:0] next_chunk;
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin: rule90_chunk
            assign next_chunk[i] = shift_reg[phase*32 + i] ^ shift_reg[phase*32 + i + 2];
        end
    endgenerate
    
    always @(posedge clk) begin
        if (load) begin
            // Load entire state and reset pipeline
            shift_reg <= {1'b0, data, 1'b0};
            q <= data;
            phase <= 0;
            processing <= 0;
        end else begin
            if (!processing) begin
                // Start new computation cycle
                processing <= 1;
                phase <= 0;
            end else begin
                // Process current phase
                shift_reg[phase*32+1 +: 32] <= next_chunk;
                phase <= phase + 1;
                
                if (phase == 15) begin
                    // Final phase - update output
                    q <= shift_reg[512:1];
                    processing <= 0;
                end
            end
        end
    end

endmodule