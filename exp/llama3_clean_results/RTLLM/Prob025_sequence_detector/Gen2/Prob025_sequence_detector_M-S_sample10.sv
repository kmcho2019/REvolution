module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

reg [3:0] seq_counter;
reg prev_data_in;

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        seq_counter <= 4'b0000;
        prev_data_in <= 1'b0;
    end else begin
        if (seq_counter == 4'b1000 && data_in == 1'b1) begin
            seq_counter <= seq_counter;
            sequence_detected <= 1'b1;
        end else if (seq_counter == 4'b0000 && data_in == 1'b1) begin
            seq_counter <= seq_counter + 1'b1;
            sequence_detected <= 1'b0;
        end else if (seq_counter == 4'b0001 && data_in == 1'b0) begin
            seq_counter <= seq_counter + 1'b1;
            sequence_detected <= 1'b0;
        end else if (seq_counter == 4'b0010 && data_in == 1'b0) begin
            seq_counter <= seq_counter + 1'b1;
            sequence_detected <= 1'b0;
        end else if (seq_counter == 4'b0011 && data_in == 1'b1) begin
            seq_counter <= seq_counter + 1'b1;
            sequence_detected <= 1'b1;
        end else begin
            seq_counter <= 4'b0000;
            sequence_detected <= 1'b0;
        end
        prev_data_in <= data_in;
    end
end

endmodule