module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] seq_count; // Counts the sequence progression
reg       prev_x;    // Stores the previous value of x
reg       seq_start; // Flags the start of the sequence

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        seq_count <= 2'b00;
        prev_x <= 1'b0;
        seq_start <= 1'b0;
    end else begin
        if (x && prev_x) begin // If we have two consecutive '1's, reset sequence
            seq_count <= 2'b00;
            seq_start <= 1'b0;
        end else if (x &&!prev_x) begin // '1' after '0', potential sequence start
            seq_count <= seq_count + 1;
            seq_start <= 1'b1;
        end else if (!x && seq_start) begin // '0' after '1', sequence continuation
            seq_count <= seq_count + 1;
            if (seq_count == 2'b10) begin // Sequence detected
                seq_count <= 2'b00;
                seq_start <= 1'b0;
            end
        end else begin // Reset sequence if '0' is not after '1'
            seq_count <= 2'b00;
            seq_start <= 1'b0;
        end
        prev_x <= x;
    end
end

// Output logic
assign z = (seq_count == 2'b10);

endmodule