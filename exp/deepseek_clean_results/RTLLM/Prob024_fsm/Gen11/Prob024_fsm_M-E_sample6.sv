module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

reg [4:0] shift_reg;  // 5-bit shift register for sequence storage
reg [2:0] seq_counter; // Counts sequence progress (0-5)

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b0;
        seq_counter <= 3'b0;
        MATCH <= 1'b0;
    end else begin
        // Shift in new bit
        shift_reg <= {shift_reg[3:0], IN};
        
        // Sequence progress tracking
        if (seq_counter == 0) begin
            if (IN) seq_counter <= 1; // Start sequence
        end else begin
            case (seq_counter)
                1: seq_counter <= (IN) ? 1 : 2; // 1->0 transition
                2: seq_counter <= (IN) ? 1 : 3; // 0->0 transition
                3: seq_counter <= (IN) ? 4 : 1; // 0->1 transition
                4: seq_counter <= (IN) ? 5 : 1; // 1->1 transition
                5: begin
                    // Reset after full sequence
                    seq_counter <= (IN) ? 1 : 0;
                end
                default: seq_counter <= 0;
            endcase
        end
        
        // Output logic - parallel match of shift register
        MATCH <= (shift_reg == 5'b10011) && (seq_counter == 5);
    end
end

endmodule