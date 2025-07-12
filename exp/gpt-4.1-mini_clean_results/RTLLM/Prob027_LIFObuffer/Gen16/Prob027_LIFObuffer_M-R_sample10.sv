module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    reg [3:0] stack_mem [0:3];
    reg [1:0] top_ptr;  // points to the current top element index when depth > 0
    reg [2:0] depth;    // number of elements in stack: 0 to 4

    integer i;

    // EMPTY and FULL flags based on depth
    assign EMPTY = (depth == 3'd0);
    assign FULL  = (depth == 3'd4);

    // Synchronous reset and enable gating
    always @(posedge Clk) begin
        if (Rst) begin
            depth <= 3'd0;
            top_ptr <= 2'd0;
            dataOut <= 4'd0;
            // Initialize stack memory to 0
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin // Write (push)
                if (!FULL) begin
                    stack_mem[depth] <= dataIn;
                    top_ptr <= depth[1:0];
                    depth <= depth + 3'd1;
                end
            end else begin        // Read (pop)
                if (!EMPTY) begin
                    dataOut <= stack_mem[top_ptr];
                    stack_mem[top_ptr] <= 4'd0;  // Optional: clear popped data
                    depth <= depth - 3'd1;
                    // Update top_ptr only if stack not empty after pop
                    if (depth > 1)
                        top_ptr <= top_ptr - 2'd1;
                end
            end
        end
    end

endmodule