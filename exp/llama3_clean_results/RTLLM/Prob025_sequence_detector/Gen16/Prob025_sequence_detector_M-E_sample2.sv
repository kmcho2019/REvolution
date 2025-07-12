module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

reg [2:0] counter; // 3-bit counter

// Counter logic
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        counter <= 3'b000;
        sequence_detected <= 1'b0;
    end else begin
        case (counter)
            3'b000: if (data_in == 1'b1) counter <= 3'b001;
            3'b001: if (data_in == 1'b0) counter <= 3'b010;
            3'b010: if (data_in == 1'b0) counter <= 3'b011;
            3'b011: if (data_in == 1'b1) begin
                counter <= 3'b000;
                sequence_detected <= 1'b1;
            end else counter <= 3'b000;
            default: counter <= 3'b000;
        endcase
        if (reset_n && counter != 3'b011) sequence_detected <= 1'b0;
    end
end

endmodule