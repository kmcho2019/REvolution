module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [1:0] state; // 2-bit state register for tracking the sequence 11
reg found_sequence; // flag to indicate if the sequence 1101 has been found

localparam IDLE = 2'b00;
localparam GOT_1 = 2'b01;
localparam GOT_11 = 2'b10;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
        found_sequence <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= GOT_1;
                end
            end
            GOT_1: begin
                if (data) begin
                    state <= GOT_11;
                end else begin
                    state <= IDLE;
                end
            end
            GOT_11: begin
                if (~data) begin // got '0' after '11'
                    state <= IDLE;
                    if (data === 1'b0 && ~found_sequence) begin // Corrected logic to handle the sequence properly
                        found_sequence <= 0; // Reset found_sequence flag if sequence isn't complete
                    end else begin
                        if (~data) begin // Check for '0'
                            found_sequence <= 1; // Set found_sequence flag when sequence is complete
                        end
                    end
                end else if (data) begin // If data is '1' after '11', it means sequence isn't 1101, reset to GOT_1
                    state <= GOT_1;
                end
            end
        endcase
    end
    start_shifting <= found_sequence;
end

endmodule