module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Define the block size
parameter BLOCK_SIZE = 8;

// Define the number of blocks
parameter NUM_BLOCKS = 255 / BLOCK_SIZE;

// Define the number of stages in the pipeline
parameter NUM_STAGES = NUM_BLOCKS;

// Define the serial counter
module serial_counter(
    input [BLOCK_SIZE-1:0] in,
    output [7:0] out
);
    reg [7:0] count;
    always @(posedge in) begin
        count = 0;
        for (int i = 0; i < BLOCK_SIZE; i++) begin
            if (in[i]) begin
                count = count + 1;
            end
        end
        out = count;
    end
endmodule

// Define the pipeline stage
module pipeline_stage(
    input [BLOCK_SIZE-1:0] in,
    input [7:0] count_in,
    output [7:0] count_out
);
    reg [7:0] count;
    serial_counter sc(
        .in(in),
        .out(count)
    );
    always @(posedge count_in) begin
        count_out = count_in + count;
    end
endmodule

// Define the pipeline
reg [7:0] count [NUM_STAGES-1:0];
always @(posedge in) begin
    count[0] = 0;
    for (int i = 0; i < NUM_BLOCKS; i++) begin
        pipeline_stage ps(
            .in(in[(i*BLOCK_SIZE)+BLOCK_SIZE-1:(i*BLOCK_SIZE)]),
            .count_in(count[i]),
            .count_out(count[i+1])
        );
    end
    out = count[NUM_STAGES-1];
end

endmodule