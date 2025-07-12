module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

reg [1:0] state;

localparam IDLE = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;
localparam S3 = 2'b11;

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
                    state <= IDLE; 
                    sequence_detected <= 1'b1;
                end else state <= IDLE;
            default: state <= IDLE;
        endcase
        if (state != S3 || data_in != 1'b1) sequence_detected <= 0;
    end
end

endmodule