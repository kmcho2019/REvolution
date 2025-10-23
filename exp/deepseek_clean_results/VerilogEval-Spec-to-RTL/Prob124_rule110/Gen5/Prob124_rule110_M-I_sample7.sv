module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [511:0] stage1, stage2;
    wire [511:0] next_state;
    integer i;

    // Compute next state only when not loading
    assign next_state = load ? q : stage2;

    // Stage 1: Compute left and right neighbors
    always @(*) begin
        if (!load) begin
            stage1 = {1'b0, q[511:1]}; // Left neighbors (shift right with 0 boundary)
        end
    end

    // Stage 2: Apply Rule 110
    always @(*) begin
        if (!load) begin
            for (i = 0; i < 512; i = i + 1) begin
                reg [2:0] pattern;
                pattern = {stage1[i], q[i], (i == 0) ? 1'b0 : q[i-1]}; // {left, center, right}

                case (pattern)
                    3'b111: stage2[i] = 1'b0;
                    3'b110: stage2[i] = 1'b1;
                    3'b101: stage2[i] = 1'b1;
                    3'b100: stage2[i] = 1'b0;
                    3'b011: stage2[i] = 1'b1;
                    3'b010: stage2[i] = 1'b1;
                    3'b001: stage2[i] = 1'b1;
                    3'b000: stage2[i] = 1'b0;
                endcase
            end
        end
    end

    // Update state on clock edge
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule