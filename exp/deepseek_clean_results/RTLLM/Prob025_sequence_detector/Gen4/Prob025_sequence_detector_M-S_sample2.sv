module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

    // State parameters
    localparam IDLE = 0;
    localparam S1   = 1;
    localparam S2   = 2;
    localparam S3   = 3;
    localparam S4   = 4;

    reg [2:0] state;

    // State transition and output logic
    always @(posedge clk) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 0;
        end
        else begin
            case (state)
                IDLE: state <= (data_in == 1'b1) ? S1 : IDLE;
                S1:   state <= (data_in == 1'b0) ? S2 : S1;
                S2:   state <= (data_in == 1'b0) ? S3 : S1;
                S3:   state <= (data_in == 1'b1) ? S4 : IDLE;
                S4:   state <= (data_in == 1'b1) ? S1 : S2;
                default: state <= IDLE;
            endcase
            
            sequence_detected <= (state == S3 && data_in == 1'b1);
        end
    end

endmodule