module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter SEG_WIDTH = 8
) (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [DATA_WIDTH-1:0] adda,
    input wire [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result,
    output reg o_en
);

// Parameter validation
initial begin
    if (DATA_WIDTH % SEG_WIDTH != 0) begin
        $error("Error: DATA_WIDTH must be divisible by SEG_WIDTH");
        $finish;
    end
end

localparam NUM_SEG = DATA_WIDTH / SEG_WIDTH;
localparam PIPELINE_DEPTH = NUM_SEG;

// Pipeline registers
reg [SEG_WIDTH-1:0] a_seg [0:NUM_SEG-1];
reg [SEG_WIDTH-1:0] b_seg [0:NUM_SEG-1];
reg [SEG_WIDTH:0] sum_seg [0:NUM_SEG-1]; // +1 bit for carry
reg [PIPELINE_DEPTH:0] en_pipe = '0;

// Carry signals
wire [NUM_SEG:0] carry;
assign carry[0] = 1'b0;

// Pipeline processing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < NUM_SEG; i = i + 1) begin
            a_seg[i] <= '0;
            b_seg[i] <= '0;
            sum_seg[i] <= '0;
        end
        en_pipe <= '0;
        result <= '0;
        o_en <= 1'b0;
    end else begin
        // Shift enable through pipeline
        en_pipe <= {en_pipe[PIPELINE_DEPTH-1:0], i_en};
        
        // Process each segment
        for (int i = 0; i < NUM_SEG; i = i + 1) begin
            if (en_pipe[i]) begin
                // Get current segment
                wire [SEG_WIDTH-1:0] a = (i == 0) ? adda[SEG_WIDTH-1:0] : a_seg[i-1];
                wire [SEG_WIDTH-1:0] b = (i == 0) ? addb[SEG_WIDTH-1:0] : b_seg[i-1];
                
                // Calculate sum with carry
                sum_seg[i] <= {1'b0, a} + {1'b0, b} + carry[i];
                carry[i+1] <= sum_seg[i][SEG_WIDTH];
                
                // Store next segment if not last
                if (i < NUM_SEG-1) begin
                    a_seg[i] <= adda[(i+1)*SEG_WIDTH +: SEG_WIDTH];
                    b_seg[i] <= addb[(i+1)*SEG_WIDTH +: SEG_WIDTH];
                end
            end
        end
        
        // Generate output when final stage is enabled
        if (en_pipe[PIPELINE_DEPTH]) begin
            result <= {carry[NUM_SEG], sum_seg[NUM_SEG-1][SEG_WIDTH-1:0]};
            for (int j = NUM_SEG-2; j >= 0; j = j - 1) begin
                result[(j+1)*SEG_WIDTH +: SEG_WIDTH] <= sum_seg[j][SEG_WIDTH-1:0];
            end
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule