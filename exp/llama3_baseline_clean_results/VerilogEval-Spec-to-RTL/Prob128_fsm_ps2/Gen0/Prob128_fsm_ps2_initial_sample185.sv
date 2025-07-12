module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 2-bit state register
reg [7:0] byte1, byte2; // registers to store bytes
reg done_reg; // register to store done signal

// Define states
localparam IDLE = 2'b00;
localparam BYTE1 = 2'b01;
localparam BYTE2 = 2'b10;
localparam BYTE3 = 2'b11;

always @(posedge clk) begin
    if (reset) begin // Reset to IDLE when reset is active high
        state <= IDLE;
        done_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3]) begin // Transition to BYTE1 when in[3]=1
                    state <= BYTE1;
                    byte1 <= in;
                end else begin
                    state <= IDLE;
                end
            end
            BYTE1: begin
                state <= BYTE2;
                byte2 <= in;
            end
            BYTE2: begin
                state <= BYTE3;
            end
            BYTE3: begin
                state <= IDLE;
                done_reg <= 1'b1; // Signal done in the next clock cycle
            end
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        done <= 1'b0;
    end else if (done_reg) begin
        done <= 1'b1; // Output done signal
        done_reg <= 1'b0; // Clear done register
    end else begin
        done <= 1'b0;
    end
end

endmodule