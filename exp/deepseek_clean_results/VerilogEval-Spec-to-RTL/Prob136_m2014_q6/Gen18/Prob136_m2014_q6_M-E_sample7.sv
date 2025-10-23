module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State transition network implemented as multiplexer tree
    reg [2:0] stage1, stage2;

    always @(posedge clk) begin
        if (reset) begin
            stage1 <= 3'b000; // Initial state A
            stage2 <= 3'b000;
            z <= 1'b0;
        end else begin
            // Stage 1: Compute next state
            case (stage2)
                3'b000: stage1 <= w ? 3'b000 : 3'b001; // A -> A or B
                3'b001: stage1 <= w ? 3'b010 : 3'b011;  // B -> D or C
                3'b011: stage1 <= w ? 3'b010 : 3'b110;  // C -> D or E
                3'b010: stage1 <= w ? 3'b000 : 3'b100;  // D -> A or F
                3'b110: stage1 <= w ? 3'b010 : 3'b110;  // E -> D or E
                3'b100: stage1 <= w ? 3'b010 : 3'b011;  // F -> D or C
                default: stage1 <= 3'b000;
            endcase

            // Stage 2: Register state and output
            stage2 <= stage1;
            z <= stage1[2]; // Output is MSB of state code
        end
    end

endmodule