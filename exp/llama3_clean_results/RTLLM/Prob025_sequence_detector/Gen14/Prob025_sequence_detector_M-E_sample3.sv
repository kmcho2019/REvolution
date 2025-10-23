module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

reg [1:0] state;
reg [3:0] counter;

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= 2'b00;
        counter <= 4'b0000;
        sequence_detected <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (data_in == 1'b1) begin
                    state <= 2'b01;
                    counter <= 4'b0001;
                end else begin
                    state <= 2'b00;
                    counter <= 4'b0000;
                end
            end
            2'b01: begin // S1 state
                if (data_in == 1'b0) begin
                    state <= 2'b10;
                    counter <= 4'b0010;
                end else begin
                    state <= 2'b00;
                    counter <= 4'b0000;
                end
            end
            2'b10: begin // S2 state
                if (data_in == 1'b0) begin
                    state <= 2'b11;
                    counter <= 4'b0011;
                end else begin
                    state <= 2'b00;
                    counter <= 4'b0000;
                end
            end
            2'b11: begin // S3 state
                if (data_in == 1'b1) begin
                    state <= 2'b00;
                    counter <= 4'b0000;
                    sequence_detected <= 1'b1;
                end else begin
                    state <= 2'b00;
                    counter <= 4'b0000;
                end
            end
        endcase
    end
end

endmodule