module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

parameter IDLE = 4'b0000;
parameter S1 = 4'b0001;
parameter S2 = 4'b0010;
parameter S3 = 4'b0011;
parameter S4 = 4'b0100;

reg [3:0] state;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
        sequence_detected <= 0;
    end else begin
        case (state)
            IDLE: 
                if (data_in == 1'b1) state <= S1;
                else state <= IDLE;
            S1: 
                if (data_in == 1'b0) state <= S2;
                else state <= IDLE;
            S2: 
                if (data_in == 1'b0) state <= S3;
                else state <= IDLE;
            S3: 
                if (data_in == 1'b1) begin
                    state <= S4;
                    sequence_detected <= 1'b1;
                end else state <= IDLE;
            S4: state <= IDLE;
            default: state <= IDLE;
        endcase
    end
end

endmodule