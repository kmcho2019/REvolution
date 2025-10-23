module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Binary state encoding
localparam IDLE   = 2'b00;
localparam GOT_0  = 2'b01;
localparam GOT_01 = 2'b10;

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        // Default output
        data_out <= 1'b0;
        
        // State transitions and output
        case (state)
            IDLE: begin
                if (data_in == 0)
                    state <= GOT_0;
                else
                    state <= IDLE;
            end
            GOT_0: begin
                if (data_in == 1)
                    state <= GOT_01;
                else
                    state <= GOT_0;
            end
            GOT_01: begin
                if (data_in == 0) begin
                    state <= IDLE;
                    data_out <= 1'b1;  // Pulse detected
                end else begin
                    state <= GOT_01;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule