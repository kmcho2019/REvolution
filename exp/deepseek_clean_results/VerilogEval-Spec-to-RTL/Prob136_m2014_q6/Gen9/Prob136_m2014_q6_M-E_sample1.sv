module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Sequence detector states (track last 2 bits)
    localparam [1:0] 
        SEQ_00 = 2'b00,
        SEQ_01 = 2'b01,
        SEQ_10 = 2'b10,
        SEQ_11 = 2'b11;

    reg [1:0] seq_state;
    reg level_state;  // 0=normal, 1=output

    // Next state logic for sequence detector
    always @(*) begin
        case (seq_state)
            SEQ_00: seq_state = w ? SEQ_01 : SEQ_00;
            SEQ_01: seq_state = w ? SEQ_11 : SEQ_10;
            SEQ_10: seq_state = w ? SEQ_01 : SEQ_00;
            SEQ_11: seq_state = w ? SEQ_11 : SEQ_10;
        endcase
    end

    // Next state logic for level detector
    always @(*) begin
        if (reset) begin
            level_state = 1'b0;
        end else begin
            case ({level_state, seq_state})
                {1'b0, SEQ_00}: level_state = 1'b0;  // Stay in normal
                {1'b0, SEQ_01}: level_state = w ? 1'b0 : 1'b1;  // To output if w=0
                {1'b0, SEQ_10}: level_state = w ? 1'b1 : 1'b0;  // To output if w=1
                {1'b0, SEQ_11}: level_state = 1'b0;  // Stay in normal
                {1'b1, SEQ_00}: level_state = 1'b1;  // Stay in output
                {1'b1, SEQ_01}: level_state = 1'b0;  // Back to normal
                {1'b1, SEQ_10}: level_state = 1'b1;  // Stay in output
                {1'b1, SEQ_11}: level_state = 1'b0;  // Back to normal
            endcase
        end
    end

    // State registers with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            seq_state <= SEQ_00;
            level_state <= 1'b0;
        end else begin
            seq_state <= seq_state;
            level_state <= level_state;
        end
    end

    // Output is simply the level state
    assign z = level_state;

endmodule