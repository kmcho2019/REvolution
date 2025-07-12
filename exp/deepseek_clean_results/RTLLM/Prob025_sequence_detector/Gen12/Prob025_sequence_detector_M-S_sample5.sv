module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// Binary encoded states
localparam IDLE = 2'b00;
localparam S1 = 2'b01;    // Got '1'
localparam S2 = 2'b10;    // Got '10'
localparam S3 = 2'b11;    // Got '100'

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                state <= (data_in == 1'b1) ? S1 : IDLE;
                sequence_detected <= 1'b0;
            end
            S1: begin
                state <= (data_in == 1'b0) ? S2 : S1;
                sequence_detected <= 1'b0;
            end
            S2: begin
                state <= (data_in == 1'b0) ? S3 : IDLE;
                sequence_detected <= 1'b0;
            end
            S3: begin
                state <= (data_in == 1'b1) ? S1 : IDLE;
                sequence_detected <= (data_in == 1'b1);
            end
        endcase
    end
end

endmodule