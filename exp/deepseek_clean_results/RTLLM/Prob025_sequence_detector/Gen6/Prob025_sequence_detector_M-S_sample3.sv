module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

    // State encoding
    reg [1:0] state;
    localparam S0 = 2'b00,
               S1 = 2'b01,
               S2 = 2'b10,
               S3 = 2'b11;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= S0;
            sequence_detected <= 1'b0;
        end else begin
            case (state)
                S0: state <= data_in ? S1 : S0;
                S1: state <= data_in ? S1 : S2;
                S2: state <= data_in ? S3 : S0;
                S3: state <= data_in ? S1 : S2;
            endcase
            sequence_detected <= (state == S3);
        end
    end

endmodule