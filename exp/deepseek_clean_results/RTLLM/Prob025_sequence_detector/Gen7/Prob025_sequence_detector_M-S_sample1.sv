module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

    reg [2:0] state;
    localparam IDLE = 3'd0,
               S1   = 3'd1,
               S2   = 3'd2,
               S3   = 3'd3,
               S4   = 3'd4;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: state <= data_in ? S1 : IDLE;
                S1:   state <= data_in ? S1 : S2;
                S2:   state <= data_in ? S3 : IDLE;
                S3:   state <= data_in ? S4 : S2;
                S4:   state <= data_in ? S1 : IDLE;
                default: state <= IDLE;
            endcase
        end
    end

    assign sequence_detected = (state == S4);

endmodule