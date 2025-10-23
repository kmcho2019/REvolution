module TopModule(
    input               clk,
    input               reset,
    input       [7:0]   in,
    output              done
);

reg [1:0] state; // 2-bit state register
reg       done_reg; // done signal register

// State encoding
localparam IDLE = 2'b00;
localparam BYTE1 = 2'b01;
localparam BYTE2 = 2'b10;
localparam BYTE3 = 2'b11;

always @(posedge clk) begin
    if (reset) begin // Synchronous reset
        state <= IDLE;
        done_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin // First byte of message
                    state <= BYTE1;
                end else begin
                    state <= IDLE; // Discard byte and stay in IDLE
                end
            end
            BYTE1: begin
                state <= BYTE2; // Move to second byte
            end
            BYTE2: begin
                state <= BYTE3; // Move to third byte
            end
            BYTE3: begin
                state <= IDLE; // Reset state after receiving message
                done_reg <= 1'b1; // Signal done
            end
        endcase
    end
end

assign done = (state == BYTE3)? 1'b1 : done_reg; // done is high for one cycle after BYTE3

// To ensure done is only high for one cycle
always @(posedge clk) begin
    if (reset || state!= BYTE3) begin
        done_reg <= 1'b0;
    end
end

endmodule