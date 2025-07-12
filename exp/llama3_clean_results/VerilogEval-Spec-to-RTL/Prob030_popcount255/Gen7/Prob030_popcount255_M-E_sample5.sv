module TopModule (
    input  [254:0] in,
    output [7:0] out
);

// Divide the input into 17 segments of 15 bits
reg [14:0] segment [16:0];

// Population count for each segment using $countones
reg [3:0] segment_count [16:0];

// Hierarchical adder structure
reg [7:0] adder_out;

// Pipeline registers
reg [7:0] pipe_reg1;
reg [7:0] pipe_reg2;

always @(*) begin
    // Initialize counts
    for (int i = 0; i < 17; i++) begin
        segment_count[i] = 4'd0;
    end
    
    // Divide the input into segments
    for (int i = 0; i < 17; i++) begin
        if (i < 16) begin
            segment[i] = in[(i*15)+:15];
        end else begin
            segment[i] = {1'b0, in[(i*15)+:14]};
        end
    end
    
    // Population count for each segment using $countones
    for (int i = 0; i < 17; i++) begin
        segment_count[i] = $countones(segment[i]);
    end
    
    // Hierarchical adder structure
    // First layer: add pairs of segment counts
    reg [4:0] layer1_out [8:0];
    for (int i = 0; i < 8; i++) begin
        layer1_out[i] = segment_count[i*2] + segment_count[i*2+1];
    end
    
    // Second layer: add pairs of layer1 outputs
    reg [5:0] layer2_out [3:0];
    for (int i = 0; i < 4; i++) begin
        layer2_out[i] = layer1_out[i*2] + layer1_out[i*2+1];
    end
    
    // Third layer: add pairs of layer2 outputs
    reg [6:0] layer3_out [1:0];
    for (int i = 0; i < 2; i++) begin
        layer3_out[i] = layer2_out[i*2] + layer2_out[i*2+1];
    end
    
    // Final addition
    reg [7:0] final_add;
    final_add = layer3_out[0] + layer3_out[1];
    
    // Pipeline the addition process
    pipe_reg1 = final_add;
    pipe_reg2 = pipe_reg1;
    adder_out = pipe_reg2;
end

assign out = adder_out;

endmodule