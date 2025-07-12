module TopModule #(
    parameter WIDTH = 32,
    parameter BYTE_SIZE = 8
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    localparam NUM_BYTES = WIDTH/BYTE_SIZE;
    
    // Direct concatenation for optimal PPA
    generate
        if (WIDTH == 32 && BYTE_SIZE == 8) begin: optimized_32bit
            assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};
        end
        else begin: generic_case
            // Generic parameterized version
            wire [BYTE_SIZE-1:0] bytes [0:NUM_BYTES-1];
            wire [BYTE_SIZE-1:0] reversed_bytes [0:NUM_BYTES-1];
            
            // Split input into bytes
            for (genvar i = 0; i < NUM_BYTES; i = i + 1) begin
                assign bytes[i] = in[(i+1)*BYTE_SIZE-1 : i*BYTE_SIZE];
            end
            
            // Reverse byte order
            for (genvar i = 0; i < NUM_BYTES; i = i + 1) begin
                assign reversed_bytes[i] = bytes[NUM_BYTES-1-i];
            end
            
            // Combine into output
            for (genvar i = 0; i < NUM_BYTES; i = i + 1) begin
                assign out[(i+1)*BYTE_SIZE-1 : i*BYTE_SIZE] = reversed_bytes[i];
            end
        end
    endgenerate
    
    /* Optional pipeline registers for timing-critical applications
    reg [WIDTH-1:0] out_reg;
    always @(posedge clk) begin
        out_reg <= out;
    end
    assign out = out_reg;
    */
endmodule