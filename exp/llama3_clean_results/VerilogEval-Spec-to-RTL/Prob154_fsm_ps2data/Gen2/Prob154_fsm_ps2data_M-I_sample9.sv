module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

// One-hot encoded state machine
reg [3:0] state;
reg [23:0] out_bytes_reg;
reg done_reg;

// State definitions
localparam IDLE = 4'b0001;
localparam BYTE1 = 4'b0010;
localparam BYTE2 = 4'b0100;
localparam BYTE3 = 4'b1000;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE; // Reset to IDLE state
        out_bytes_reg <= 24'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    out_bytes_reg[23:16] <= in; // Store first byte
                    state <= BYTE1; // Transition to BYTE1 state
                end
            end
            BYTE1: begin
                out_bytes_reg[15:8] <= in; // Store second byte
                state <= BYTE2; // Transition to BYTE2 state
            end
            BYTE2: begin
                out_bytes_reg[7:0] <= in; // Store third byte
                state <= BYTE3; // Transition to BYTE3 state
            end
            BYTE3: begin
                done_reg <= 1'b1; // Signal done
                state <= IDLE; // Transition back to IDLE state
            end
            default: begin
                state <= IDLE; // Default to IDLE state
            end
        endcase
        if (state!= BYTE3) begin // Not in BYTE3 state
            done_reg <= 1'b0; // Clear done signal
        end
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule