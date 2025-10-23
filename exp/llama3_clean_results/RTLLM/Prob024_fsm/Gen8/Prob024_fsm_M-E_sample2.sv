module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// 3-bit counter to keep track of consecutive matches
logic [2:0] match_cnt;

// 2-bit counter to keep track of the current position in the target sequence
logic [1:0] seq_pos;

// Target sequence
logic [4:0] target_seq = 5'b10011;

// Asynchronous reset
always @(RST or posedge CLK) begin
    if (RST) begin
        match_cnt <= 3'b000;
        seq_pos <= 2'b00;
        MATCH <= 1'b0;
    end else begin
        // Check if the input bit matches the corresponding bit in the target sequence
        if (IN == target_seq[4 - seq_pos]) begin
            // Increment the match counter
            match_cnt <= match_cnt + 1'b1;
            // Increment the sequence position counter
            seq_pos <= seq_pos + 1'b1;
            // Check if we have reached the end of the target sequence
            if (seq_pos == 2'b10) begin
                // Set the MATCH output to 1
                MATCH <= 1'b1;
                // Reset the match counter and sequence position counter
                match_cnt <= 3'b000;
                seq_pos <= 2'b00;
            end
        end else begin
            // Reset the match counter and sequence position counter
            match_cnt <= 3'b000;
            seq_pos <= 2'b00;
            // Set the MATCH output to 0
            MATCH <= 1'b0;
        end
    end
end

endmodule